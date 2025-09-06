import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clear_footprint/models/ai_frequency_model.dart';

// AI 설정 페이지
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedFrequencyIndex = 0; // 기본 선택된 빈도 인덱스 (첫 번째 항목)
  static const String _frequencyKey =
      'ai_frequency_index'; // SharedPreferences 키

  // AI 활용 빈도 옵션들 (모델에서 가져오기)
  final List<String> frequencies = AiFrequencyModel.frequencies;

  @override
  void initState() {
    super.initState();
    _loadFrequency(); // 앱 시작 시 저장된 빈도 불러오기
  }

  // 저장된 빈도를 불러오는 메서드
  Future<void> _loadFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_frequencyKey) ?? 0; // 기본값은 0

    // 인덱스가 유효한 범위 내에 있는지 확인
    if (savedIndex >= 0 && savedIndex < frequencies.length) {
      setState(() {
        selectedFrequencyIndex = savedIndex;
      });
    }
  }

  // 선택된 빈도를 저장하는 메서드
  Future<void> _saveFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_frequencyKey, selectedFrequencyIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '설정',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI 활용 빈도 설정 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 섹션 제목
                  Text(
                    'AI 활용 빈도 설정',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 12),

                  // // 설명 텍스트
                  // Text(
                  //   'AI를 얼마나 자주 활용하시나요?\n환경 보호 활동에 AI가 도움이 되는 정도를 알려주세요.',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey[600],
                  //     height: 1.5,
                  //   ),
                  // ),
                  SizedBox(height: 6),

                  // 빈도 선택 리스트
                  ...frequencies.asMap().entries.map((entry) {
                    final index = entry.key;
                    final frequency = entry.value;
                    final isSelected = selectedFrequencyIndex == index;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? primaryColor : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? backgroundColor : whiteColor,
                      ),
                      child: ListTile(
                        title: Text(
                          frequency,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: isSelected ? primaryColor : Colors.black87,
                          ),
                        ),
                        leading: Radio<int>(
                          value: index,
                          groupValue: selectedFrequencyIndex,
                          onChanged: (value) {
                            setState(() {
                              selectedFrequencyIndex = value!;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                        onTap: () {
                          setState(() {
                            selectedFrequencyIndex = index;
                          });
                        },
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 24),

                  // 저장 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 선택된 빈도를 SharedPreferences에 저장
                        await _saveFrequency();

                        // 저장 완료 메시지 표시
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'AI 활용 빈도가 "${frequencies[selectedFrequencyIndex]}"로 설정되었습니다.',
                              ),
                              backgroundColor: primaryColor,
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // 설정이 변경되었음을 알리기 위해 true 반환
                          Navigator.pop(context, true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
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
          ],
        ),
      ),
    );
  }
}
