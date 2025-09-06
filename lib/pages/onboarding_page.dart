import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/main.dart';
import 'package:clear_footprint/services/auth_service.dart';

// 온보딩 페이지 - ChatGPT CO2 배출 경각심 제공
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false; // Google 로그인 진행 상태

  // 온보딩 페이지 데이터
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: '안녕하세요!\n맑은발자국 입니다',
      description: '우리의 무분별한 생성형 AI의 이용이 \n환경에 미치는 영향을 함께 알아보세요',
      icon: Icons.eco,
      color: primaryColor,
    ),
    OnboardingData(
      title: 'ChatGPT 한 번 호출할 때마다',
      description: '약 1.332g의 CO₂가 대기 중으로 배출됩니다.',
      icon: Icons.cloud_outlined,
      color: Colors.orange,
    ),
    OnboardingData(
      title: '이는 자동차로 10m 주행한 것과\n같은 탄소 배출량입니다',
      description: '작은 호출이지만 누적되면 큰 영향을 미쳐요.',
      icon: Icons.directions_car,
      color: Colors.red,
    ),
    OnboardingData(
      title: 'AI 사용이 지구에 미치는 영향을\n두 발로 체감해봐요',
      description: '구글 계정으로 로그인 해볼까요?',
      icon: Icons.favorite,
      color: primaryColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 진행 표시바
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(
                  _onboardingData.length,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color:
                            index <= _currentPage
                                ? primaryColor
                                : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 온보딩 콘텐츠
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 아이콘
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: data.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(data.icon, size: 60, color: data.color),
                        ),

                        const SizedBox(height: 40),

                        // 제목
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 설명
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),

                        // CO2 배출량 강조 (두 번째 페이지)
                        if (index == 1) ...[
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              '💡 하루에 100번 사용하면 133.2g의 CO₂ 배출!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],

                        // Google Fit 로그인 버튼 (마지막 페이지)
                        if (index == _onboardingData.length - 1) ...[
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () {
                                        _signInWithGoogleFit();
                                      },
                              icon:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(
                                        Icons.fitness_center,
                                        size: 24,
                                      ),
                              label: Text(
                                _isLoading ? '로그인 중...' : 'Google로 시작하기',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isLoading ? Colors.grey : primaryColor,
                                foregroundColor: whiteColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // 하단 버튼들
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 다음 버튼 (마지막 페이지가 아닌 경우에만 표시)
                  if (_currentPage < _onboardingData.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        // 다음 페이지로 이동
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  // Google 로그인 처리 메서드
  Future<void> _signInWithGoogleFit() async {
    if (_isLoading) return; // 이미 로그인 진행 중이면 리턴

    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });

    try {
      final authService = AuthService();
      final result = await authService.signInWithGoogle();

      if (result != null && result.user != null) {
        // 로그인 성공 - 메인 화면으로 이동
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainTabView()),
          );
        }
      } else {
        // 로그인 실패 또는 취소
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('로그인이 취소되었습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // 로그인 오류 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 상태 종료
        });
      }
    }
  }
}

// 온보딩 데이터 클래스
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
