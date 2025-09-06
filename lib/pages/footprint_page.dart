import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';

// 탄소발자국 페이지
class FootprintPage extends StatelessWidget {
  const FootprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('탄소발자국'),
        backgroundColor: secondaryColor,
      ),
      backgroundColor: backgroundColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 80, color: primaryColor),
            SizedBox(height: 20),
            Text(
              '탄소발자국 관리',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('환경을 위한 첫 걸음을 시작해보세요', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
