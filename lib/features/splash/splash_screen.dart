import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/auth/view/login_page.dart';
import 'package:vigo_smart_app/features/home/view/home_page.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final sessionManager = SessionManager();
    final isLoggedIn = await sessionManager.isLoggedIn();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const HomePage() : const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_screen.jpg',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
 }
