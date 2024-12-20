import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/theme/theme.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'features/splash/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final sessionManager = SessionManager();
  final isLoggedIn = await sessionManager.isLoggedIn();
  runApp(CalendarControllerProvider(
      controller: EventController(), child: MyApp(isLoggedIn: isLoggedIn)));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo.',
      theme: AppTheme.lightThemeMode,
      home: const SplashScreen(),
    );
  }
}
