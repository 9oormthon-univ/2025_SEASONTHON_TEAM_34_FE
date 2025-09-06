import 'dart:async';
import 'package:clear_footprint/widgets/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/services/location_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clear_footprint/models/ai_frequency_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 기록 페이지
class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  double _todayDistance = 0.0;
  bool _isLoading = true;
  Timer? _updateTimer;

  // AI 사용 빈도 인덱스 (기본값 0)
  int _frequencyIndex = 0;

  // 일일 목표 거리 (calculateWalkingDistance로 계산됨)
  double get _dailyGoalDistance =>
      AiFrequencyModel.calculateWalkingDistance(_frequencyIndex);

  // 마지막으로 사용한 빈도 인덱스 저장 키
  static const String _lastFrequencyKey = 'last_frequency_index';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeLocationTracking();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 포커스를 받았을 때 빈도 인덱스 다시 로드
      _loadFrequencyIndex();
    }
  }

  // 위치 추적 및 자동 업데이트 초기화
  Future<void> _initializeLocationTracking() async {
    // AI 사용 빈도 인덱스 먼저 로드
    await _loadFrequencyIndex();

    // 초기 거리 데이터 로드
    await _loadTodayDistance();

    // GPS 추적 자동 시작
    await _locationService.startLocationTracking();

    // 1초마다 자동 업데이트 시작
    _startAutoUpdate();
  }

  // 오늘의 이동거리 불러오기
  Future<void> _loadTodayDistance() async {
    try {
      final distance = await _locationService.getTodayTotalDistance();
      if (mounted) {
        setState(() {
          _todayDistance = distance;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('거리 데이터 로드 실패: $e');
    }
  }

  // 1초마다 자동 업데이트 시작
  void _startAutoUpdate() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _loadTodayDistance();
      } else {
        timer.cancel();
      }
    });
  }

  // AI 사용 빈도 인덱스 불러오기
  Future<void> _loadFrequencyIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex =
          prefs.getInt('ai_frequency_index') ?? 0; // home_page와 같은 키 사용
      final lastIndex = prefs.getInt(_lastFrequencyKey) ?? -1; // 마지막으로 사용한 인덱스

      // 빈도가 변경되었다면 거리 데이터 리셋
      if (lastIndex != -1 && lastIndex != savedIndex) {
        await _resetTodayDistance();
        print('AI 사용 빈도가 변경되어 오늘의 이동거리를 리셋했습니다.');
      }

      // 현재 빈도 인덱스를 마지막 사용 인덱스로 저장
      await prefs.setInt(_lastFrequencyKey, savedIndex);

      if (mounted) {
        setState(() {
          _frequencyIndex = savedIndex;
        });
      }
    } catch (e) {
      print('빈도 인덱스 로드 실패: $e');
      // 에러 발생 시 기본값(0) 유지
    }
  }

  // 오늘의 이동거리 리셋
  Future<void> _resetTodayDistance() async {
    try {
      await _locationService.resetTodayDistance();
      if (mounted) {
        setState(() {
          _todayDistance = 0.0;
        });
      }
    } catch (e) {
      print('거리 리셋 실패: $e');
    }
  }

  // 도넛 차트 위젯 생성
  Widget _buildDonutChart() {
    double progressPercentage = (_todayDistance / _dailyGoalDistance).clamp(
      0.0,
      1.0,
    );
    double remainingPercentage = 1.0 - progressPercentage;

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 도넛 차트
          PieChart(
            PieChartData(
              centerSpaceRadius: 60,
              sectionsSpace: 2,
              sections: [
                // 완료된 부분
                PieChartSectionData(
                  color: primaryColor,
                  value: progressPercentage * 100,
                  title: '',
                  radius: 25,
                ),
                // 남은 부분
                PieChartSectionData(
                  color: Colors.grey.withOpacity(0.3),
                  value: remainingPercentage * 100,
                  title: '',
                  radius: 25,
                ),
              ],
            ),
          ),
          // 중앙 텍스트
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progressPercentage * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AiFrequencyModel.formatDistance(_todayDistance),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                '/ ${AiFrequencyModel.formatDistance(_dailyGoalDistance)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 설정 변경 시 콜백 함수
  void _onResume() {
    // _loadFrequency(); // 설정 변경 시 빈도 다시 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '맑은발자국',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        backgroundColor: primaryColor,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: whiteColor), // 사이드바 버튼
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: ProfileDrawer(
        onSettingsChanged: _onResume, // 설정 변경 시 콜백
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 이동거리 도넛 그래프
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '일일 목표 달성률',
                      style: TextStyle(fontSize: 20, color: blackColor),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator(color: primaryColor)
                        : _buildDonutChart(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 이동거리 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '오늘 이동한 거리',
                      style: TextStyle(fontSize: 20, color: blackColor),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator(color: primaryColor)
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              size: 48,
                              color: primaryColor,
                            ),
                            Text(
                              AiFrequencyModel.formatDistance(_todayDistance),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 안내 메시지 (간단히)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✅ GPS가 자동으로 거리를 추적하고 있습니다\n실시간으로 거리 정보가 업데이트됩니다',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
