import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';

// 기록 페이지
class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기록'), backgroundColor: secondaryColor),
      backgroundColor: backgroundColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dock, size: 80, color: primaryColor),
            SizedBox(height: 20),
            Text(
              '사용자 기록',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('계정 정보 및 설정을 관리하세요', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
