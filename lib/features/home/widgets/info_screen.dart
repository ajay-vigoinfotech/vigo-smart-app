import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/view/login_page.dart';
import '../../auth/viewmodel/getuserdetails_view_model.dart';

class InfoScreen extends StatefulWidget {
  final double barheight;

  const InfoScreen({super.key, required this.barheight});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final SessionManager sessionManager = SessionManager();

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
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: AppConstants.settingsIcon,
                title: const Text('Settings'),
                onTap: () {
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
      height: widget.barheight,
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

    sessionManager.getToken().then((token) async {
      final UserViewModel userViewModel = UserViewModel();

      userViewModel.getUserDetails(token!);
      sessionManager.getUserDetails().then((data) async {
        print("emp code: ${data.employeeCode}");
      }).catchError((onError) {
        print(onError.toString());
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }
}
