import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
import 'package:vigo_smart_app/features/markduty/view/markduty_page.dart';
import 'package:vigo_smart_app/features/punchHistory/view/punch_history.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils.dart';
import '../../auth/model/checksession_model.dart';
import '../../auth/model/getlastselfieattendancemodel.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/view/login_page.dart';
import '../../auth/viewmodel/checksession_view_model.dart';
import '../../auth/viewmodel/getuserdetails_view_model.dart';
import '../viewmodel/modules_view_model.dart';
import '../widgets/home_screen_card.dart';
import '../widgets/info_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sessionManager = SessionManager();
  String? employeeCode;
  String? compCode;
  String? compName;
  String? name;
  String? punchTimeDateIn;

  final List<Map<String, dynamic>> allModules = [
    {
      'code': 'FieldReportingApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.fieldReportingApp,
      'color': Pallete.greenColor,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'FieldReportingQRApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.fieldReportingQRApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'SupervisorQRDutyManagementApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.supervisorQRDutyManagementApp,
      'color': Pallete.btn1,
      'page': const PunchHistory(),
    },
    {
      'code': 'PunchHistory',
      'icon': AppConstants.punchHistoryIcon,
      'name': Strings.punchHistory,
      'color': Pallete.blueColor,
      'page': const PunchHistory(),
    },
    {
      'code': 'SyncData',
      'icon': AppConstants.syncDataIcon,
      'name': Strings.syncData,
      'color': Pallete.vibrantOrangeColor,
      'page': const SettingPage(),
    },
    {
      'code': 'SettingsApp',
      'icon': AppConstants.settingsIcon,
      'name': Strings.settingsApp,
      'color': Pallete.greyColor,
      'page': const SettingPage(),
    },
    {
      'code': 'SupervisorDutyManagementApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.calendarViewApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'SiteReportingApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.siteReportingApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'SiteReportingQRApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.siteReportingQRApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'TeamViewApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.teamViewApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'OtherAttendanceApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.otherAttendanceApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'GuardsTeamView',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.guardsTeamView,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'PaySlipApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.paySlipApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'RecruitmentApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.recruitmentApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'CalendarViewApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.calendarViewApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
    {
      'code': 'LeaveMgmtApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.leaveMgmtApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
    },
  ];

  List<Map<String, dynamic>> filteredModules = [];

  @override
  void initState() {
    super.initState();
    checkUserSession();
    sessionManager.getModuleCodes().then((savedModules) {
      if (savedModules != null && savedModules.isNotEmpty) {
        setState(() {
          filteredModules = allModules
              .where((module) => savedModules.contains(module['code']))
              .toList();
        });
      } else {
        // If no modules are saved, keep filteredModules empty or handle as needed
        filteredModules = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 10,
      //   title: const Text(
      //     'Vigo Smart App v1.0',
      //     style: TextStyle(fontWeight: FontWeight.w600),
      //   ),
      //   centerTitle: false,
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.menu),
      //   ),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           _showBottomSheet(context);
      //         },
      //         icon: const Icon(Icons.settings))
      //   ],
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const InfoScreen(barHeight: 150),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: filteredModules.length, // Display filtered modules
                itemBuilder: (context, index) {
                  final module = filteredModules[index];
                  return HomeScreenCard(
                    icon: module['icon'],
                    modulename: module['name'],
                    cardColor: module['color'],
                    nextPage: module['page'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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
                  Icons.refresh,
                  color: Colors.black54,
                ), // Corrected syntax
                title: const Text('Refresh Server Data'),
                onTap: () {
                  Navigator.pop(context);
                  getUserData();
                  lastSelfieAtt(SelfieAttendanceModel());
                  getModules();
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.settings,
              //     color: Colors.black54,
              //   ), // Corrected syntax
              //   title: const Text('Settings'),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SettingPage(),
              //       ),
              //     );
              //   },
              // ),
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

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Handle Option 1 action
        break;
      case 1:
        // Handle Option 2 action
        break;
    }
  }

  Future<void> checkUserSession() async {
    final SessionManager sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null || token.isEmpty) {
      debugPrint('Failed to retrieve token.');
      return;
    }

    final CheckSessionViewModel checkSessionViewModel = CheckSessionViewModel();
    String? fcmToken = await Utils.getFCMToken();
    final String appVersion = await Utils.getAppVersion();
    final response = await checkSessionViewModel.checkSession(
      token,
      CheckSessionModel(
        fcmToken: fcmToken,
        appVersion: appVersion,
      ),
    );

    /**
     * 401 - token expire
     * 402 - company inactive
     * 403 - user inactive
     * 400 - general exception
     */
    if (response == 401) {
      reLoginDialog();
    } else if(response == 402 || response == 403){
      sessionManager.logout();
    }
  }

  Future<Scaffold> reLoginDialog() async{
    return const Scaffold(

    );
  }


}
