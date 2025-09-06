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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/character.png', width: 100, height: 100),
            Container(width: 360, height: 100, color: whiteColor),
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
