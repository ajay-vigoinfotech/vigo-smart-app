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
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TeamViewScreen(),
//     );
//   }
// }
//
// class TeamViewScreen extends StatelessWidget {
//   Widget buildCard(String title, String label1, String value1, Color color1,
//       String label2, String value2, Color color2) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     label1,
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     value1,
//                     style: TextStyle(fontSize: 16, color: color1),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text(
//                     label2,
//                     style: TextStyle(color: Colors.green),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     value2,
//                     style: TextStyle(fontSize: 16, color: color2),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text(
//                     'LATE',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     '4', // Example data
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Text(
//                     'ABSENT',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     '4', // Example data
//                     style: TextStyle(fontSize: 16, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.black, backgroundColor: Colors.white,
//               side: BorderSide(color: Colors.black),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Check List'),
//                 Icon(Icons.arrow_right_alt),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Team View'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             buildCard('Attendance', 'Total EMP', '4', Colors.blue, 'PRESENT', '4', Colors.green),
//             buildCard('Field Reporting', 'Total EMP', '4', Colors.blue, 'Done', '0', Colors.green),
//             buildCard('Site Reporting', 'Total EMP', '4', Colors.blue, 'Done', '0', Colors.green),
//           ],
//         ),
//       ),
//     );
//   }
// }
