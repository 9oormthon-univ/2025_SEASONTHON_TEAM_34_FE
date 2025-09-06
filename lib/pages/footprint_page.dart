import 'package:clear_footprint/widgets/profile_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/pages/ranking_page.dart';

const data = [
  {'date': '2025-09-07', 'distance': 12.3, 'success': true},
  {'date': '2025-09-06', 'distance': 45.6, 'success': true},
  {'date': '2025-09-05', 'distance': 7.89, 'success': false},
  {'date': '2025-09-04', 'distance': 10.12, 'success': true},
  {'date': '2025-09-03', 'distance': 12.34, 'success': true},
  {'date': '2025-09-02', 'distance': 14.56, 'success': true},
  {'date': '2025-09-01', 'distance': 16.78, 'success': true},
];

// 탄소발자국 페이지
class FootprintPage extends StatelessWidget {
  const FootprintPage({super.key});

  // 기존 데이터를 역순으로 정렬 (오래된 순서대로)
  List<Map<String, dynamic>> _getWeeklyData() {
    return data.reversed.toList();
  }

  // 요일 문자 반환
  String _getDayOfWeek(DateTime date) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[date.weekday - 1];
  }

  // 설정 변경 시 콜백 함수
  void _onResume() {
    // _loadFrequency(); // 설정 변경 시 빈도 다시 불러오기
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final weeklyData = _getWeeklyData();

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/character.png',
                width: 160,
                height: 160,
              ),
              const SizedBox(height: 10),

              // 주간 달력
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 요일 헤더
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          weeklyData.map((item) {
                            final date = DateTime.parse(item['date']);
                            return Text(
                              _getDayOfWeek(date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // 날짜와 아이콘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          weeklyData.map((item) {
                            final date = DateTime.parse(item['date']);
                            final isSuccess = item['success'] as bool;

                            return Column(
                              children: [
                                // 날짜 표시
                                Text(
                                  '${date.month}/${date.day}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: blackColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 성공 표시 아이콘
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        isSuccess
                                            ? primaryColor
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    isSuccess ? Icons.check : Icons.close,
                                    color: isSuccess ? whiteColor : Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 8),

                    // 거리 데이터
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          weeklyData.map((item) {
                            final distance = item['distance'] as double;

                            return Text(
                              '${distance.toStringAsFixed(2)}km',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

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
                      '${user?.displayName ?? '사용자'}님의 순위',
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
                        Icon(Icons.emoji_events, color: primaryColor, size: 48),
                        const SizedBox(width: 12),
                        Text(
                          '5위',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 랭킹 보기 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RankingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '전체 랭킹 보기',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
