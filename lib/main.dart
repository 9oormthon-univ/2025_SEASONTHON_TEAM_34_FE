import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/pages/record_page.dart';
import 'package:clear_footprint/pages/home_page.dart';
import 'package:clear_footprint/pages/footprint_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clear Footprint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      home: const MainTabView(),
    );
  }
}

// 메인 탭 뷰 위젯 - 하단 네비게이션 바 관리
class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentIndex = 1; // 현재 선택된 탭 인덱스

  // 각 탭에 해당하는 페이지 위젯들
  final List<Widget> _pages = [
    const RecordPage(),
    const HomePage(),
    const FootprintPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // 현재 선택된 탭의 페이지 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 탭 변경 시 인덱스 업데이트
          });
        },
        type: BottomNavigationBarType.fixed, // 3개 이상의 탭을 위해 fixed 타입 사용
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.border_color), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: '탄소발자국'),
        ],
        backgroundColor: secondaryColor,
        unselectedIconTheme: const IconThemeData(size: 36),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        selectedIconTheme: const IconThemeData(size: 40),
        selectedItemColor: primaryColor,
        selectedLabelStyle: const TextStyle(fontSize: 0),
      ),
    );
  }
}
