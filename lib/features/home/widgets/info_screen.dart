import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
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
  String? employeeCode; //TBS24
  String? compCode; //Tiger
  String? compName; //TIGER 4 INDIA LIMITED
  String? name; //PlayStore ID

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _logout(BuildContext context) async {
    final sessionManager = SessionManager();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                await sessionManager.logout();

                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
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
        });
      }).catchError((onError) {
        print(onError.toString());
      });
    }).catchError((error) {
      print('Error: $error');
    });
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SettingPage()));
                },
              ),
              ListTile(
                leading: AppConstants.logoutIcon,
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop();
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  '$employeeCode - '
                  '$name\n'
                  '$compName',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible, // Prevents text overflow
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    // refresh logic here
                    //getUserData(); // Option to refresh the user data
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

//   Future<void> getToken() async {
//     final SessionManager sessionManager = SessionManager();
//
//     sessionManager.getToken().then((token) async {
//       final GetlastselfieattViewModel getlastselfieattViewModel =
//           GetlastselfieattViewModel();
//       getlastselfieattViewModel.getLastSelfieAttendance(token!).then( (data1) async {
//         sessionManager.getCheckinData().then((data) async {
//           print(data.checkinId);
//           print(data.uniqueId);
//           print(data.dateTimeIn);
//           print(data.dateTimeOut);
//           print(data.inKmsDriven);
//           print(data.outKmsDriven);
//           print(data.siteId);
//           print(data.siteName);
//         });
//       });
//     }).catchError((error) {
//       print('Error: $error');
//     });
//   }
}
