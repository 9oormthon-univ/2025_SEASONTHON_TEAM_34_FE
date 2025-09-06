// AI 활용 빈도와 일당 사용 횟수 매핑 모델
class AiFrequencyModel {
  static const List<String> frequencies = [
    '지피티 유료 버전 사용할 정도로 미쳐있어요',
    '지피티 무료 버전을 쓰긴 하는데 부족해요',
    '지피티 무료 버전을 적당히 사용해요',
    '일 1-2회',
    '주 1-2회',
    '월 2-3회',
    '거의 사용 안해요',
  ];

  // 각 빈도에 따른 일당 평균 AI 사용 횟수
  static const List<double> dailyUsageCounts = [
    100.0, // 지피티 유료 버전 사용할 정도로 미쳐있어요
    50.0, // 지피티 무료 버전을 쓰긴 하는데 부족해요
    15.0, // 지피티 무료 버전을 적당히 사용해요
    1.5, // 일 1-2회
    0.2, // 주 1-2회 (1.5/7)
    0.08, // 월 2-3회 (2.5/30)
    0.01, // 거의 사용 안해요
  ];

  // 탄소 배출 계수 (kg CO₂ per query) - 수식에서 0.001332kg 사용
  static const double carbonEmissionFactorKg = 0.001332;

  // 걷기 탄소 배출 계수 (kg CO₂ per km)
  static const double walkingEmissionFactor = 0.1252;

  // 인덱스로부터 일당 사용 횟수 가져오기
  static double getDailyUsageCount(int index) {
    if (index >= 0 && index < dailyUsageCounts.length) {
      return dailyUsageCounts[index];
    }
    return 0.0; // 기본값
  }

  // 인덱스로부터 빈도 문자열 가져오기
  static String getFrequencyText(int index) {
    if (index >= 0 && index < frequencies.length) {
      return frequencies[index];
    }
    return frequencies[0]; // 기본값
  }

  // 일당 탄소 배출량 계산 (g CO₂) - 표시용
  static double calculateDailyCarbonEmission(int frequencyIndex) {
    final dailyUsage = getDailyUsageCount(frequencyIndex);
    return dailyUsage * (carbonEmissionFactorKg * 1000); // kg을 g으로 변환
  }

  // 포맷된 탄소 배출량 문자열 반환
  static String getFormattedCarbonEmission(int frequencyIndex) {
    final emission = calculateDailyCarbonEmission(frequencyIndex);
    return emission.toStringAsFixed(1);
  }

  // 걸어야 하는 거리 계산 (m)
  // 수식: max(0.001332kg Co2 * 생성형 AI 활용 횟수 / 0.1252 kg/km, 2.9km)
  static double calculateWalkingDistance(int frequencyIndex) {
    final dailyUsage = getDailyUsageCount(frequencyIndex);

    // AI 사용으로 인한 탄소 배출량 (kg CO₂) - 수식 그대로 적용
    final carbonEmissionKg = carbonEmissionFactorKg * dailyUsage;

    // 걸어야 하는 거리 계산
    final walkingDistance = carbonEmissionKg / walkingEmissionFactor;

    return walkingDistance * 1000;
  }

  // 포맷된 걷기 거리 문자열 반환
  static String getFormattedWalkingDistance(int frequencyIndex) {
    final distance = calculateWalkingDistance(frequencyIndex);
    return distance.toStringAsFixed(1);
  }
}
