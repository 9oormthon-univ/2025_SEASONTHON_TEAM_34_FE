// AI 활용 빈도와 일당 사용 횟수 매핑 모델
class AiFrequencyModel {
  static const List<String> frequencies = [
    'GPT 유료 버전을 사용하는데 부족해요',
    'GPT 유료 버전을 적당히 사용해요',
    'GPT 무료 버전을 사용하는데 부족해요',
    'GPT 무료 버전을 적당히 사용해요',
    '거의 사용 안해요',
  ];

  // 각 빈도에 따른 일당 평균 AI 사용 횟수
  static const List<double> dailyUsageCounts = [
    1280.0, // GPT 유료 버전을 사용하는데 부족해요
    100.0, // GPT 유료 버전을 적당히 사용해요
    50.0, // GPT 무료 버전을 사용하는데 부족해요
    20.0, // GPT 무료 버전을 적당히 사용해요
    1.0, // 거의 사용 안해요
  ];

  // 각 빈도에 따른 메시지 (인덱스 순서와 동일)
  static const List<String> messages = [
    "😅 에휴... 이정도로 쓰시면\n얼마나 걸어야 하는지 알아요?", // GPT 유료 버전 부족
    "😤 AI 좀 적당히 쓰세요!\n이만큼 걸어야 해요", // GPT 유료 버전 적당히
    "😏 무료도 이렇게 쓰시면\n이만큼은 걸어야죠~", // GPT 무료 버전 부족
    "😊 적당히 쓰시는군요!\n이정도만 걸으면 돼요", // GPT 무료 버전 적당히
    "😍 오~ 환경 지킴이시네요!\n이것만 걸으면 충분해요", // 거의 사용 안함
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

  // 인덱스로부터 빈도에 따른 메시지 가져오기
  static String getFrequencyMessage(int index) {
    if (index >= 0 && index < messages.length) {
      return messages[index];
    }
    return messages[0]; // 기본값
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

  // 거리를 적절한 단위로 포맷팅
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      double km = meters / 1000;
      return '${km.toStringAsFixed(2)} km';
    }
  }
}
