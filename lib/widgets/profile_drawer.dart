import 'package:flutter/material.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/widgets/ai_frequency_modal.dart';

// 프로필 사이드바 위젯
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              currentAccountPicture: CircleAvatar(
                backgroundColor: whiteColor,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: primaryColor,
                ), // 프로필 아이콘
              ),
              accountName: Text(
                '사용자 이름',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('user@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.home, color: primaryColor),
              title: Text('홈', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.eco, color: primaryColor),
              title: Text('탄소 발자국', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // 탄소 발자국 페이지로 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment, color: primaryColor),
              title: Text('기록', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // 기록 페이지로 이동
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: primaryColor),
              title: Text('설정', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // AI 활용 빈도 설정 모달 표시
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => const AiFrequencyModal(),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: Text('로그아웃', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                // 로그아웃 기능
              },
            ),
          ],
        ),
      ),
    );
  }
}
