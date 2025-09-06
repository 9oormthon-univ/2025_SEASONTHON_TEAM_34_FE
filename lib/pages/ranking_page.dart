import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';

// 랭킹 데이터 (예시)
const rankingData = [
  {'rank': 1, 'name': '김환경', 'distance': 45.6, 'isCurrentUser': false},
  {'rank': 2, 'name': '이자연', 'distance': 38.2, 'isCurrentUser': false},
  {'rank': 3, 'name': '박그린', 'distance': 32.8, 'isCurrentUser': false},
  {'rank': 4, 'name': '최친환', 'distance': 28.4, 'isCurrentUser': false},
  {'rank': 5, 'name': '사용자', 'distance': 25.1, 'isCurrentUser': true},
  {'rank': 6, 'name': '정에코', 'distance': 22.7, 'isCurrentUser': false},
  {'rank': 7, 'name': '한지구', 'distance': 18.9, 'isCurrentUser': false},
  {'rank': 8, 'name': '윤클린', 'distance': 15.3, 'isCurrentUser': false},
  {'rank': 9, 'name': '김환경', 'distance': 45.6, 'isCurrentUser': false},
  {'rank': 10, 'name': '김환경', 'distance': 45.6, 'isCurrentUser': false},
];

// 랭킹 페이지
class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '랭킹',
          style: TextStyle(
            color: blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 상위 3명 표시
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 2등
                    _buildTopRanker(
                      rankingData[1],
                      Icons.looks_two,
                      Colors.grey,
                    ),
                    // 1등
                    _buildTopRanker(
                      rankingData[0],
                      Icons.looks_one,
                      const Color(0xFFFFD700),
                    ),
                    // 3등
                    _buildTopRanker(
                      rankingData[2],
                      Icons.looks_3,
                      const Color(0xFFCD7F32),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 전체 랭킹 리스트
              Expanded(
                child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '전체 랭킹',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: rankingData.length,
                          itemBuilder: (context, index) {
                            final user = rankingData[index];
                            final isCurrentUser = user['isCurrentUser'] as bool;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    isCurrentUser
                                        ? primaryColor.withOpacity(0.1)
                                        : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    isCurrentUser
                                        ? Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        )
                                        : null,
                              ),
                              child: Row(
                                children: [
                                  // 순위
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _getRankColor(user['rank'] as int),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${user['rank']}',
                                        style: const TextStyle(
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // 이름
                                  Expanded(
                                    child: Text(
                                      user['name'] as String,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            isCurrentUser
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color: blackColor,
                                      ),
                                    ),
                                  ),

                                  // 거리
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${(user['distance'] as double).toStringAsFixed(1)}km',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              isCurrentUser
                                                  ? primaryColor
                                                  : blackColor,
                                        ),
                                      ),
                                      if (isCurrentUser)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            'ME',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 상위 3명 위젯 생성
  Widget _buildTopRanker(
    Map<String, dynamic> user,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, color: whiteColor, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          user['name'] as String,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
        Text(
          '${(user['distance'] as double).toStringAsFixed(1)}km',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // 순위에 따른 색상 반환
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 금색
      case 2:
        return Colors.grey; // 은색
      case 3:
        return const Color(0xFFCD7F32); // 동색
      default:
        return primaryColor;
    }
  }
}
