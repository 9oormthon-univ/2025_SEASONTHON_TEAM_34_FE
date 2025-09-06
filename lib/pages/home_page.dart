import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/widgets/profile_drawer.dart';
import 'package:clear_footprint/models/ai_frequency_model.dart';
import 'package:clear_footprint/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 홈 페이지
class HomePage extends StatefulWidget {
  final Function(int)? onDrawerPageChanged; // 드로워에서 페이지 변경을 위한 콜백

  const HomePage({super.key, this.onDrawerPageChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedFrequencyIndex = 0; // 기본값
  static const String _frequencyKey =
      'ai_frequency_index'; // SharedPreferences 키

  @override
  void initState() {
    super.initState();
    _loadFrequency(); // 저장된 빈도 불러오기
  }

  // 저장된 빈도를 불러오는 메서드
  Future<void> _loadFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_frequencyKey) ?? 0; // 기본값은 0

    // 인덱스가 유효한 범위 내에 있는지 확인
    if (savedIndex >= 0 && savedIndex < AiFrequencyModel.frequencies.length) {
      setState(() {
        selectedFrequencyIndex = savedIndex;
        // 걸어야 하는 거리도 함께 업데이트
      });
    }
  }

  // 설정 변경 시 콜백 함수
  void _onResume() {
    _loadFrequency(); // 설정 변경 시 빈도 다시 불러오기
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

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
      backgroundColor: backgroundColor,
      drawer: ProfileDrawer(
        onSettingsChanged: _onResume, // 설정 변경 시 콜백
        onPageChanged: widget.onDrawerPageChanged, // 페이지 변경 콜백
      ), // 프로필 사이드바
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/character.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user?.displayName} 님!',
                        style: TextStyle(
                          fontSize: 20,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        AiFrequencyModel.getFrequencyMessage(
                          selectedFrequencyIndex,
                        ),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),

              // GPT 사용 빈도 변경 안내 섹션
              GestureDetector(
                onTap: () async {
                  // 설정 페이지로 이동
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );

                  // 설정이 변경되었으면 빈도 다시 로드
                  if (result == true) {
                    _onResume();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '혹시 최근 GPT 사용 빈도가 바뀌셨나요?',
                      style: TextStyle(fontSize: 16, color: blackColor),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.settings, color: blackColor, size: 16),
                  ],
                ),
              ),

              SizedBox(height: 20),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 사용으로 인한 탄소 배출량',
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColor,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud, color: primaryColor, size: 48),
                        SizedBox(width: 12),
                        Text(
                          "${AiFrequencyModel.getFormattedCarbonEmission(selectedFrequencyIndex)} g CO₂",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_outlined, color: grayColor, size: 20),
                    Text(
                      'AI 1회 사용 시 탄소배출량',
                      style: TextStyle(fontSize: 20, color: grayColor),
                    ),
                    Text(
                      '1.332 g CO₂',
                      style: TextStyle(fontSize: 20, color: grayColor),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '탄소 상쇄를 위해 걸어야 하는 거리',
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColor,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.straighten, color: primaryColor, size: 48),
                        SizedBox(width: 12),
                        Text(
                          AiFrequencyModel.formatDistance(
                            double.parse(
                              AiFrequencyModel.getFormattedWalkingDistance(
                                selectedFrequencyIndex,
                              ),
                            ),
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
