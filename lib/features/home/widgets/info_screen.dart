import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigo_smart_app/features/home/viewmodel/modules_view_model.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/model/getlastselfieattendancemodel.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/view/login_page.dart';
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
  String? punchTimeDateIn;

  @override
  void initState() {
    super.initState();
    getUserData();
    lastSelfieAtt(SelfieAttendanceModel());
    getModules();
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
                    lastSelfieAtt(SelfieAttendanceModel());
                    getModules();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => //etToken(),
                      _showBottomSheet(context),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Future<void> lastSelfieAtt(
      SelfieAttendanceModel selfieAttendanceModel) async {
    final SessionManager sessionManager = SessionManager();
    try {
      await sessionManager.saveSelfieAttendance(selfieAttendanceModel);
      print('Selfie Attendance saved successfully!!!!!!!!!');
    } catch (error) {
      print('Error saving selfie attendance: $error');
    }
  }

  Future<void> getModules() async {
    ModulesViewModel modulesViewModel = ModulesViewModel();
    String? token = await sessionManager.getToken();

    if (token != null && token.isNotEmpty) {
      List<String> modules = await modulesViewModel.getModules(token);

      if (modules.isNotEmpty) {
        print('Modules fetched: $modules');
      } else {
        print('No Modules Found');
      }
    } else {
      print('No Token Found');
    }
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
}

// Future<void> getToken() async {
//   final SessionManager sessionManager = SessionManager();
//   sessionManager.getToken().then((token) async {
//     final GetlastselfieattViewModel getlastselfieattViewModel =
//         GetlastselfieattViewModel();
//     getlastselfieattViewModel.getLastSelfieAttendance(token!).then( (data1) async {
//       sessionManager.getCheckinData().then((data) async {
//         print(data.uniqueId);
//       });
//     });
//   }
//   ).catchError((error) {
//     print('Error: $error');
//   });
// }
//
// Future<void> getToken() async {
//   final SessionManager sessionManager = SessionManager();
//   final token = await sessionManager.getToken();
//
//   if (token == null || token.isEmpty) {
//     print('Failed to retrieve token.');
//     return;
//   }
//
//   final GetSelfieAttendanceViewModel getSelfieAttendanceViewModel = GetSelfieAttendanceViewModel();
//   final GetSelfieAttendanceViewModel? viewModel = await getSelfieAttendanceViewModel.getSelfieAttendance(token);
//
//   if (viewModel != null && viewModel.getSelfieAttendanceModel != null) {
//     final SelfieAttendanceTable? selfieAttendance = viewModel.getSelfieAttendanceModel!.table?.first;
//
//     if (selfieAttendance != null) {
//       print('Comp ID: ${selfieAttendance.compId}');
//       print('Date Time In: ${selfieAttendance.dateTimeIn}');
//       print('Data Time Out: ${selfieAttendance.dateTimeOut}');
//       print('Location: ${selfieAttendance.location}');
//       print('Location: ${selfieAttendance.outLocation}');
//       print('In Photo: ${selfieAttendance.inPhoto}');
//       print('Out Photo: ${selfieAttendance.outPhoto}');
//       print('In Remarks: ${selfieAttendance.inRemarks}');
//       print('In Kms Driven: ${selfieAttendance.inKmsDriven}');
//     } else {
//       print('No attendance data available.');
//     }
//   } else {
//     print('Failed to fetch attendance data.');
//   }
// }

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
