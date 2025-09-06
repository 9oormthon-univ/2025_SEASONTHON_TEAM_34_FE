import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 위치 추적 서비스
class LocationService {
  static const String _locationDataKey = 'location_data';
  static const String _todayDateKey = 'today_date';
  static const String _totalDistanceKey = 'total_distance';

  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;
  double _totalDistanceToday = 0.0;
  DateTime? _lastValidPositionTime;

  // 위치 권한 요청 (항상 허용 강제)
  Future<bool> requestLocationPermission() async {
    // GPS 서비스 활성화 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // GPS가 비활성화된 경우 설정으로 이동
      await Geolocator.openLocationSettings();
      return false;
    }

    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();

    // 권한이 없거나 제한적인 경우 항상 허용 요청
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();

      // 여전히 항상 허용이 아닌 경우
      if (permission != LocationPermission.always) {
        // 설정 앱으로 이동하여 수동으로 항상 허용 설정하도록 안내
        await openAppSettings();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부된 경우 설정 앱으로 이동
      await openAppSettings();
      return false;
    }

    // 항상 허용만 true 반환
    return permission == LocationPermission.always;
  }

  // 백그라운드 위치 추적 시작
  Future<void> startLocationTracking() async {
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) return;

    // 오늘 날짜 확인 및 데이터 초기화
    await _checkAndResetDailyData();

    // 위치 스트림 설정 (정확도 우선, 최소 거리 2m)
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // 2미터 이상 이동했을 때만 업데이트
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _updatePosition(position);
    });
  }

  // 위치 추적 중지
  void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // 위치 업데이트 처리
  void _updatePosition(Position newPosition) async {
    if (_lastPosition != null) {
      // 이전 위치와 현재 위치 사이의 거리 계산
      double distance = _calculateDistance(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );
      print('distance: $distance');
      // 거리가 100m 미만일 때만 추가 (오류 방지)
      if (distance < 4) {
        _totalDistanceToday += distance;
        await _saveLocationData(newPosition);
      }
    }

    _lastPosition = newPosition;
  }

  // 두 위치 사이의 거리 계산 (haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // 미터 단위 거리
  }

  // 도를 라디안으로 변환
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // 오늘 날짜 확인 및 데이터 초기화
  Future<void> _checkAndResetDailyData() async {
    final prefs = await SharedPreferences.getInstance();
    final today =
        DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
    final savedDate = prefs.getString(_todayDateKey);

    if (savedDate != today) {
      // 새로운 날이면 데이터 초기화
      _totalDistanceToday = 0.0;
      await prefs.setString(_todayDateKey, today);
      await prefs.setDouble(_totalDistanceKey, 0.0);
      await prefs.remove(_locationDataKey);
    } else {
      // 같은 날이면 저장된 거리 불러오기
      _totalDistanceToday = prefs.getDouble(_totalDistanceKey) ?? 0.0;
    }
  }

  // 위치 데이터 저장
  Future<void> _saveLocationData(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_totalDistanceKey, _totalDistanceToday);

    // 위치 히스토리도 저장 (선택사항)
    final locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    List<String> locationHistory = prefs.getStringList(_locationDataKey) ?? [];
    locationHistory.add(jsonEncode(locationData));

    // 최대 100개의 위치만 저장 (메모리 절약)
    if (locationHistory.length > 100) {
      locationHistory = locationHistory.sublist(locationHistory.length - 100);
    }

    await prefs.setStringList(_locationDataKey, locationHistory);
  }

  // 오늘의 총 이동거리 조회 (미터 단위)
  Future<double> getTodayTotalDistance() async {
    await _checkAndResetDailyData();
    return _totalDistanceToday;
  }

  // 현재 위치 한번만 가져오기
  Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('위치 가져오기 실패: $e');
      return null;
    }
  }

  // 위치 추적 상태 확인
  bool get isTracking => _positionStream != null;

  // 오늘의 이동거리 리셋 (AI 빈도 변경 시 사용)
  Future<void> resetTodayDistance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _totalDistanceToday = 0.0;
      await prefs.setDouble(_totalDistanceKey, 0.0);
      print('오늘의 이동거리가 리셋되었습니다.');
    } catch (e) {
      print('거리 리셋 실패: $e');
      throw e;
    }
  }
}
