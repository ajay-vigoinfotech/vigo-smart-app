import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
import 'package:vigo_smart_app/features/markduty/view/markduty_page.dart';
import 'package:vigo_smart_app/features/punchHistory/view/punch_history.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils.dart';
import '../../auth/model/checksession_model.dart';
import '../../auth/model/getlastselfieattendancemodel.dart';
import '../../auth/model/login_model.dart';
import '../../auth/model/marklogin_model.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/view/login_page.dart';
import '../../auth/viewmodel/checksession_view_model.dart';
import '../../auth/viewmodel/getlastselfieatt_view_model.dart';
import '../../auth/viewmodel/getuserdetails_view_model.dart';
import '../../auth/viewmodel/login_sucess_view_model.dart';
import '../../auth/viewmodel/login_view_model.dart';
import '../viewmodel/modules_view_model.dart';
import '../widgets/home_screen_card.dart';

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
  String? userName;
  String? name;
  String? punchTimeDateIn;
  String helplineNo = '';
  String? helpLineWhatsapp = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController partnerCodeController = TextEditingController();
  TextEditingController userIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final LoginViewModel _viewModel = LoginViewModel();
  final MarkLoginViewModel markLoginViewModel = MarkLoginViewModel();
  final UserViewModel userViewModel = UserViewModel();
  final GetlastselfieattViewModel getlastselfieattViewModel =
      GetlastselfieattViewModel();
  final CheckSessionViewModel checkSessionViewModel = CheckSessionViewModel();

  final List<Map<String, dynamic>> allModules = [
    {
      'code': 'FieldReportingApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.fieldReportingApp,
      'color': Colors.grey,
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
      'code': 'SupervisorDutyManagementApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.supervisorDutyManagementApp,
      'color': Pallete.btn1,
      'page': const MarkdutyPage(),
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
    getUserData().then((_) {
      getModules();
      refreshServerData();
    });
    checkUserSession();
    sessionManager.getModuleCodes().then((savedModules) {
      if (savedModules != null && savedModules.isNotEmpty) {
        setState(() {
          filteredModules = allModules
              .where((module) => savedModules.contains(module['code']))
              .toList();
        });
      } else {
        filteredModules = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text(
          'Vigo Smart App v1.0',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          _buildEmployeeInfo(employeeCode, name, compName, compCode),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: sessionManager.getModuleCodes().then((savedModules) {
                return allModules
                    .where((module) =>
                        savedModules != null &&
                        savedModules.contains(module['code']))
                    .toList();
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final module = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: HomeScreenCard(
                            icon: module['icon'],
                            modulename: module['name'],
                            cardColor: module['color'],
                            nextPage: module['page'],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No modules found'));
                }
              },
            ),
          ),
          _buildSupportContact(),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget _buildEmployeeInfo(
      String? employeeCode, String? name, String? compName, String? compCode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(
              '${employeeCode ?? "-"} - ${name ?? "-"}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Text(
              '${compName ?? "-"} (${compCode ?? "-"})',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportContact() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _launchDialer(helplineNo),
                child: const Icon(
                  Icons.support_agent_sharp,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              GestureDetector(
                onTap: () => _launchDialer(helplineNo),
                child: Text(
                  helplineNo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5), // Spacer

        // WhatsApp support
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _launchWhatsApp(helpLineWhatsapp!),
                child: SvgPicture.asset(
                  'assets/icons/whatsapp.svg',
                  width: 35,
                  height: 35,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => _launchWhatsApp(helpLineWhatsapp!),
                child: Text(
                  helpLineWhatsapp!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                ),
                title: const Text('Refresh Server Data'),
                onTap: () {
                  Navigator.pop(context);
                  getUserData();
                  lastSelfieAtt(SelfieAttendanceModel());
                  getModules();
                  refreshServerData();
                },
              ),
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

  // Get Filtered Modules
  Future<void> getModules() async {
    ModulesViewModel modulesViewModel = ModulesViewModel();
    String? token = await sessionManager.getToken();

    if (token != null && token.isNotEmpty) {
      List<String> modules = await modulesViewModel.getModules(token);

      if (modules.isNotEmpty) {
        debugPrint('Modules fetched: $modules');
        await sessionManager
            .saveModuleCodes(modules); // Save modules to session
        refreshServerData(); // Refresh data after saving modules
      } else {
        debugPrint('No Modules Found');
      }
    } else {
      debugPrint('No Token Found');
    }
  }

// Function to refresh server data
  void refreshServerData() async {
    List<String>? updatedModules = await sessionManager.getModuleCodes();

    if (updatedModules != null && updatedModules.isNotEmpty) {
      setState(() {
        filteredModules = allModules
            .where((module) => updatedModules.contains(module['code']))
            .toList();
      });
    } else {
      setState(() {
        filteredModules = [];
      });
    }
  }

  // Function to launch the Dialer
  Future<void> _launchDialer(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $number';
    }
  }

  // Function to launch WhatsApp
  Future<void> _launchWhatsApp(String number) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': number,
        'text': 'Hello',
      },
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'Could not launch WhatsApp with $number';
    }
  }

  //Function for Logout
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

// Function to Get User Details
  Future<void> getUserData() async {
    try {
      final sessionManager = SessionManager();
      String? token = await sessionManager.getToken();

      if (token != null && token.isNotEmpty) {
        final userViewModel = UserViewModel();
        await userViewModel.getUserDetails(token);

        var data = await sessionManager.getUserDetails();

        setState(() {
          employeeCode = data.employeeCode ?? "-";
          name = data.name ?? "-";
          compCode = data.compCode ?? "-";
          compName = data.compName ?? "-";
          helplineNo = data.helplineNo ?? "-";
          helpLineWhatsapp = data.helpLineWhatsapp ?? "-";
        });
      } else {
        debugPrint('No Token Found');
      }
    } catch (error) {
      debugPrint('Error fetching user data: $error');
    }
  }

  Future<void> lastSelfieAtt(
      SelfieAttendanceModel selfieAttendanceModel) async {
    final SessionManager sessionManager = SessionManager();
    try {
      await sessionManager.saveSelfieAttendance(selfieAttendanceModel);
      debugPrint('Selfie Attendance saved successfully!!!!!!!!!');
    } catch (error) {
      debugPrint('Error saving selfie attendance: $error');
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
      reLoginDialog(context);
    } else if (response == 402 || response == 403) {
      sessionManager.logout();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = "${partnerCodeController.text}/${userIDController.text}";
      final loginRequest = LoginRequest(
        grantType: Strings.grantType,
        username: username,
        password: passwordController.text,
      );

      final success = await _viewModel.makeRequest(loginRequest);

      if (success) {
        final sessionManager = SessionManager();
        await sessionManager.saveLoginInfo(username);

        sessionManager.getToken().then((token) async {
          final String formattedDateTime = Utils.getCurrentFormattedDateTime();
          final String deviceDetails = await Utils.getDeviceDetails(context);
          final String appVersion = await Utils.getAppVersion();
          final String ipAddress = await Utils.getIpAddress();
          final String uniqueId = await Utils.getUniqueID();
          final int battery = await Utils.getBatteryLevel();
          final String? fcmToken = await Utils.getFCMToken();

          final String fullDeviceDetails =
              "$deviceDetails/$uniqueId/$ipAddress";

          final markLoginModel = MarkLoginModel(
            deviceDetails: fullDeviceDetails,
            punchAction: 'LOGIN.',
            locationDetails: '',
            batteryStatus: '$battery%',
            time: formattedDateTime,
            latLong: '',
            version: 'v$appVersion',
            fcmToken: fcmToken ?? '',
            dataStatus: '',
          );

          final markLoginResponse =
              await markLoginViewModel.markLogin(token!, markLoginModel);

          if (markLoginResponse is String &&
              markLoginResponse == "Device Logged-In successfully.") {
            Fluttertoast.showToast(
              msg: markLoginResponse,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 17.0,
            );
          }

          ModulesViewModel moduleService = ModulesViewModel();
          List<String> moduleCodes = await moduleService.getModules(token);

          List<String> distinctModuleCodes = moduleCodes.toSet().toList();
          await sessionManager.saveModuleCodes(distinctModuleCodes);

          sessionManager.getModuleCodes().then((savedModuleCodes) {
            //print(savedModuleCodes);
          });

          userViewModel.getUserDetails(token);
          getlastselfieattViewModel.getLastSelfieAttendance(token);
        }).catchError((error) {
          //print('Error: $error');
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Login failed. Please try again.',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> reLoginDialog(BuildContext context) async {
    bool isPasswordVisible = false;
    final SessionManager sessionManager = SessionManager();

    sessionManager.getUserDetails().then((data) {
      partnerCodeController.text = data.compCode!;
      userIDController.text = data.employeeCode!;
      passwordController.text = '';
    });

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            "Re-Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite, // Make dialog width responsive
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: partnerCodeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Partner Code',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: userIDController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 10.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 10.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await _onSubmit();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Re-Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
