import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/viewmodel/getuserdetails_view_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? employeeCode;
  String? name;
  String? compCode;
  String? compName;
  String? userName;
  String? department;
  bool isPushEnabled = true;
  bool isAutoCheckInEnabled = true;
  int autoCheckInterval = 30;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$employeeCode',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('$name'),
                    const SizedBox(height: 4),
                    Text('$department'),
                    const SizedBox(height: 4),
                    Text('$compName'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Push Notifications'),
              value: isPushEnabled,
              onChanged: (bool value) {
                setState(() {
                  isPushEnabled = value;
                });
              },
            ),
            const ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('AutoCheckin Status: ON'),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: Text('AutoCheckIn Interval: $autoCheckInterval mins'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text('Rate App'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Privacy Policy'),
              onTap: () async {
                Uri url = Uri.parse(AppConstants.privacyPolicyUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserData() async {
    final SessionManager sessionManager = SessionManager();
    sessionManager.getToken().then((token) async {
      final UserViewModel userViewModel = UserViewModel();
      userViewModel.getUserDetails(token!);
      sessionManager.getUserDetails().then((data) async {
        setState(() {
          employeeCode = data.employeeCode;
          name = data.name;
          compCode = data.compCode;
          compName = data.compName;
          userName = data.userName;
          department = data.department;
        });
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Settings'),
//       centerTitle: false,
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView(
//         children: [
//           // Employee Info Card
//           Card(
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '$employeeCode',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Text('$name'),
//                   const SizedBox(height: 4),
//                   Text('$department'),
//                   const SizedBox(height: 4),
//                   Text('$compName'),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Settings Options Card
//           Card(
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   SwitchListTile(
//                     title: const Text('Enable Push Notifications'),
//                     value: isPushEnabled,
//                     onChanged: (bool value) {
//                       setState(() {
//                         isPushEnabled = value;
//                       });
//                     },
//                   ),
//                   const ListTile(
//                     leading: Icon(Icons.check_circle_outline),
//                     title: Text('AutoCheckin Status: ON'),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.timer),
//                     title: Text('AutoCheckIn Interval: $autoCheckInterval'),
//                   ),
//                   const Divider(),
//                   ListTile(
//                     leading: const Icon(Icons.star_border),
//                     title: const Text('Rate App'),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.phone),
//                     title: const Text('Contact us'),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.info_outline),
//                     title: const Text('About us'),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.security),
//                     title: const Text('Privacy Policy'),
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
