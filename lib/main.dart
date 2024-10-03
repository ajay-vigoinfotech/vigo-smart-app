import 'dart:ui';
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
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo.',
      theme: AppTheme.lightThemeMode,
      home: const SplashScreen(),
    );
  }
}



// import 'package:flutter/material.dart';
//
// class PunchInOutScreen extends StatefulWidget {
//   @override
//   _PunchInOutScreenState createState() => _PunchInOutScreenState();
// }
//
// class _PunchInOutScreenState extends State<PunchInOutScreen> {
//   bool _hasCheckedIn = false; // Tracks if the user has punched in
//   bool _hasCheckedOut = false; // Tracks if the user has punched out
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Punch In/Out"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Punch-IN Button
//             ElevatedButton(
//               onPressed: _hasCheckedIn
//                   ? null // Disable if already punched in
//                   : () async {
//                 // Simulate the punch-in action
//                 // Here you would call your actual punch-in API
//                 print("Punched In");
//                 setState(() {
//                   _hasCheckedIn = true;
//                   _hasCheckedOut = false; // Enable the OUT button
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green, // Background color
//               ),
//               child: Text('Punch IN'),
//             ),
//             SizedBox(height: 20),
//             // Punch-OUT Button
//             ElevatedButton(
//               onPressed: (!_hasCheckedIn || _hasCheckedOut)
//                   ? null // Disable if not punched in or already punched out
//                   : () async {
//                 // Simulate the punch-out action
//                 // Here you would call your actual punch-out API
//                 print("Punched Out");
//                 setState(() {
//                   _hasCheckedOut = true;
//                   _hasCheckedIn = false; // Reset IN button after punching out
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red, // Background color
//               ),
//               child: Text('Punch OUT'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: PunchInOutScreen(),
//   ));
// }
//
