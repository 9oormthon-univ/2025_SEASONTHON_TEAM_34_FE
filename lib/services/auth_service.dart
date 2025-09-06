import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Google 로그인 및 사용자 인증 서비스 클래스
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Firebase 프로젝트의 OAuth 2.0 웹 클라이언트 ID
    serverClientId:
        '634447878064-29bsk4rdf2fvv905ospt822dcj1mqrr9.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // 현재 사용자 가져오기
  User? get currentUser => _auth.currentUser;

  // 사용자 로그인 상태 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google 로그인 진행
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google 로그인 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // 사용자가 로그인을 취소한 경우
        return null;
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 자격 증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );

      // 로그인 성공 시 SharedPreferences에 상태 저장
      if (result.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', result.user!.email ?? '');
        await prefs.setString('userName', result.user!.displayName ?? '');
      }

      return result;
    } catch (e) {
      print('Google 로그인 오류: $e');
      return null;
    }
  }

  // 로그아웃 처리
  Future<void> signOut() async {
    try {
      // Firebase 로그아웃
      await _auth.signOut();

      // Google 로그아웃
      await _googleSignIn.signOut();

      // SharedPreferences에서 로그인 상태 제거
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userEmail');
      await prefs.remove('userName');
    } catch (e) {
      print('로그아웃 오류: $e');
    }
  }

  // 로그인 상태 확인 (SharedPreferences 기반)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // 사용자 정보 가져오기 (SharedPreferences 기반)
  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('userEmail'),
      'name': prefs.getString('userName'),
    };
  }

  // 앱 초기화 시 자동 로그인 시도
  Future<User?> tryAutoLogin() async {
    try {
      // SharedPreferences에서 로그인 상태 확인
      final isLoggedIn = await this.isLoggedIn();

      if (isLoggedIn && currentUser != null) {
        return currentUser;
      }

      // Google 자동 로그인 시도 (Silent Sign In)
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signInSilently();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential result = await _auth.signInWithCredential(
          credential,
        );
        return result.user;
      }

      return null;
    } catch (e) {
      print('자동 로그인 오류: $e');
      return null;
    }
  }
}
