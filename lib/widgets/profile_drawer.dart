import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clear_footprint/color.dart';
import 'package:clear_footprint/pages/settings_page.dart';
import 'package:clear_footprint/services/auth_service.dart';

// 프로필 사이드바 위젯
class ProfileDrawer extends StatelessWidget {
  final VoidCallback? onSettingsChanged; // 설정 변경 시 호출될 콜백

  const ProfileDrawer({super.key, this.onSettingsChanged});

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 가져오기
    final User? user = FirebaseAuth.instance.currentUser;

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
                backgroundImage:
                    user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                child:
                    user?.photoURL == null
                        ? Icon(Icons.person, size: 50, color: primaryColor)
                        : null, // 구글 프로필 이미지 또는 기본 아이콘
              ),
              accountName: Text(
                user?.displayName ?? '지킴이', // 구글 계정 이름 또는 기본값
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                user?.email ?? 'user@example.com',
              ), // 구글 계정 이메일 또는 기본값
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
              onTap: () async {
                Navigator.pop(context);
                // 설정 페이지로 이동하고 결과를 기다림
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );

                // 설정이 변경되었다면 콜백 호출
                if (result == true && onSettingsChanged != null) {
                  onSettingsChanged!();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: Text('로그아웃', style: TextStyle(fontSize: 16)),
              onTap: () async {
                Navigator.pop(context);
                // 실제 로그아웃 기능 구현
                await AuthService().signOut();
                // 온보딩 페이지로 이동 (로그인 페이지)
                Navigator.of(
                  // ignore: use_build_context_synchronously
                  context,
                ).pushNamedAndRemoveUntil('/onboarding', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
