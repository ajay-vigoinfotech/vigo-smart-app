import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/view/login_page.dart';

class InfoScreen extends StatelessWidget {
  final double barheight;

  const InfoScreen({super.key, required this.barheight});

  Future<void> _logout(BuildContext context) async {
    final sessionManager = SessionManager();
    await sessionManager.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200, // Adjusted height for better responsiveness
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: AppConstants.settingsIcon,
                title: const Text('Settings'),
                onTap: () {
                  // Handle settings action
                },
              ),
              ListTile(
                leading: AppConstants.logoutIcon,
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barheight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Pallete.btn1,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text('VIGO INFOTECH PVT LTD VIGO85',
                  style: TextStyle(
                      fontSize: 14), // Adjusted font size for readability
                  overflow: TextOverflow.visible // Prevents text overflow
                  ),
            ),
            Row(
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    // refresh logic here
                  },
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    // notification logic here
                  },
                  icon: const Icon(Icons.notifications),
                ),
                GestureDetector(
                  onTap: () => //getToken(),
                      _showBottomSheet(context),
                  child: const CircleAvatar(
                    radius: 30, // Adjusted radius for better UI balance
                    //backgroundImage: AssetImage('assets/images/login_image.jpeg'), // Placeholder image
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getToken() async {
    final SessionManager sessionManager = SessionManager();

    sessionManager.getToken().then((token) async {}).catchError((error) {
      print('Error: $error');
    });
  }
}
