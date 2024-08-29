import 'package:flutter/material.dart';
import '../auth/view/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  // Starts the timer for the splash screen and navigates to the login page after the delay.
  void _startSplashScreenTimer() async {
    const duration = Duration(seconds: 3);
    await Future.delayed(duration);
    _navigateToLogin();
  }

  // Navigates to the login page.
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
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
