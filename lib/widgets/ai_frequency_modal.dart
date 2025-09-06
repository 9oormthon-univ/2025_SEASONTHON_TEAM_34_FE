import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';

// AI 활용 빈도 선택 모달 위젯
class AiFrequencyModal extends StatefulWidget {
  const AiFrequencyModal({super.key});

  @override
  State<AiFrequencyModal> createState() => _AiFrequencyModalState();
}

class _AiFrequencyModalState extends State<AiFrequencyModal> {
  String selectedFrequency = '매일'; // 선택된 빈도

  // AI 활용 빈도 옵션들
  final List<String> frequencies = [
    '지피티 유료 버전 사용할 정도로 미쳐있어요',
    '지피티 무료 버전을 쓰긴 하는데 부족해요',
    '지피티 무료 버전을 적당히 사용해요',
    '일 1-2회',
    '주 1-2회',
    '월 2-3회',
    '거의 사용 안해요',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54, // 반투명 배경
      child: SafeArea(
        child: Stack(
          children: [
            // 배경을 눌렀을 때 모달 닫기
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            // 실제 모달 컨텐츠
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AI 활용 빈도 설정',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // 설명 텍스트
                    Text(
                      'AI를 얼마나 자주 활용하시나요?\n환경 보호 활동에 AI가 도움이 되는 정도를 알려주세요.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),

                    // 빈도 선택 리스트
                    ...frequencies
                        .map(
                          (frequency) => Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    selectedFrequency == frequency
                                        ? primaryColor
                                        : Colors.grey[300]!,
                                width: selectedFrequency == frequency ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  selectedFrequency == frequency
                                      ? backgroundColor
                                      : whiteColor,
                            ),
                            child: ListTile(
                              title: Text(
                                frequency,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      selectedFrequency == frequency
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      selectedFrequency == frequency
                                          ? primaryColor
                                          : Colors.black87,
                                ),
                              ),
                              leading: Radio<String>(
                                value: frequency,
                                groupValue: selectedFrequency,
                                onChanged: (value) {
                                  setState(() {
                                    selectedFrequency = value!;
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedFrequency = frequency;
                                });
                              },
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                        )
                        .toList(),

                    SizedBox(height: 24),

                    // 저장 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 선택된 빈도를 저장하는 로직 (나중에 SharedPreferences 등으로 구현)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'AI 활용 빈도가 "$selectedFrequency"로 설정되었습니다.',
                              ),
                              backgroundColor: primaryColor,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '저장하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
