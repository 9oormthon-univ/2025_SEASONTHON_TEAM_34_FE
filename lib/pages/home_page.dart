import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';

// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈'), backgroundColor: secondaryColor),
      backgroundColor: backgroundColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: primaryColor),
            SizedBox(height: 20),
            Text(
              '홈 페이지',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Clear Footprint에 오신 것을 환영합니다!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
