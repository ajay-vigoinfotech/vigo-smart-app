import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
import 'package:vigo_smart_app/features/markduty/view/markduty_page.dart';
import 'package:vigo_smart_app/features/punchHistory/view/punch_history.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/session_manager/session_manager.dart';
import '../widgets/home_screen_card.dart';
import '../widgets/info_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sessionManager = SessionManager();

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
      'page':  const PunchHistory(),
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
}
