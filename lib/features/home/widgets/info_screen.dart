import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/view/login_page.dart';
import '../../auth/viewmodel/getlastselfieatt_view_model.dart';
import '../../auth/viewmodel/getuserdetails_view_model.dart';

class InfoScreen extends StatefulWidget {
  final double barHeight;

  const InfoScreen({super.key, required this.barHeight});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final SessionManager sessionManager = SessionManager();
  String? employeeCode;
  String? compCode;
  String? compName;
  String? name;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ), // Corrected syntax
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black54,
                ),
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
      height: widget.barHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Pallete.btn1,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '$employeeCode - $name \n$compName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  iconSize: 28,
                  onPressed: () {
                    getUserData();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => //getCurrentDateTime(),
                      _showBottomSheet(context),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    // backgroundImage: AssetImage('assets/images/login_image.jpeg'), // You can uncomment if using an image
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> getToken() async {
  final SessionManager sessionManager = SessionManager();

  sessionManager.getToken().then((token) async {
    final GetlastselfieattViewModel getlastselfieattViewModel =
        GetlastselfieattViewModel();
    getlastselfieattViewModel.getLastSelfieAttendance(token!).then( (data1) async {
      sessionManager.getCheckinData().then((data) async {
        print(data.uniqueId);
        print(data.dateTimeIn);
        print(data.dateTimeOut);
        print(data.inKmsDriven);
        print(data.outKmsDriven);
        print(data.siteId);
        print(data.siteName);
      });
    });
  }
  ).catchError((error) {
    print('Error: $error');
  });
}

// Future<void> getCurrentDateTime() async {
//   final sessionManager = SessionManager();
//   final getCurrentDateViewModel = GetCurrentDateViewModel();
//
//   // Fetch current date from the API
//   final currentDateTime = await getCurrentDateViewModel.getTimeDate();
//
//   // Format the API result to the desired format
//   final formattedDateTime = Utils.formatDateTime(currentDateTime!);
//
//   // Save the formatted date in SharedPreferences
//   await sessionManager.saveCurrentDateTime(formattedDateTime);
//
//   // Get the saved date from SharedPreferences
//   final savedDate = await sessionManager.getTimeDate();
//   print('Saved Date from SharedPreferences: $savedDate');
// }

//   Future<void> getToken() async {
//     // Assuming SessionManager is already implemented to manage tokens
//     final sessionManager = SessionManager();
//     final token = await sessionManager.getToken(); // Example usage
//
//     final supportContactViewModel = SupportContactViewModel();
//
//     // Fetch and store support contact using the ViewModel
//     final supportContact = await supportContactViewModel.getSupportContact();
//     print('Support Contact: $supportContact');
//   }

// Future<void> getToken() async {
//   final sessionManager = SessionManager();
//
//   final checkSessionViewModel = CheckSessionModel();
//
//   final checkSession = await CheckSessionViewModel();
// }
