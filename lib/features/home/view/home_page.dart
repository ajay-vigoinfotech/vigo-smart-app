import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/home/widgets/setting_page.dart';
import 'package:vigo_smart_app/features/punchHistory/view/punch_history.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';
import '../../../core/theme/app_pallete.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../markduty/view/mark_duty_page.dart';
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
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'PunchHistory',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.punchHistory,
      'color': Pallete.btn1,
      'page': const PunchHistory(),
    },
    {
      'code': 'SettingsApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.settingsApp,
      'color': Pallete.btn1,
      'page': const SettingPage(),
    },
    {
      'code': 'SupervisorDutyManagementApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.calendarViewApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'SupervisorQRDutyManagementApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.supervisorQRDutyManagementApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'FieldReportingQRApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.fieldReportingQRApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'SiteReportingApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.siteReportingApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },    {
      'code': 'SiteReportingQRApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.siteReportingQRApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'TeamViewApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.teamViewApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'OtherAttendanceApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.otherAttendanceApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'SyncData',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.syncData,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'GuardsTeamView',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.guardsTeamView,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },    {
      'code': 'PaySlipApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.paySlipApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },    {
      'code': 'RecruitmentApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.recruitmentApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'CalendarViewApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.calendarViewApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
    {
      'code': 'LeaveMgmtApp',
      'icon': AppConstants.markDutyIcon,
      'name': Strings.leaveMgmtApp,
      'color': Pallete.btn1,
      'page': const MarkDutyPage(),
    },
  ];

  List<Map<String, dynamic>> filteredModules = [];

  @override
  void initState() {
    super.initState();
    sessionManager.getModuleCodes().then((savedModules) {
      // Check if savedModules is not null and contains values
      if (savedModules != null && savedModules.isNotEmpty) {
        setState(() {
          // Filter allModules based on savedModules (which contains codes)
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
    final screenHeight = MediaQuery.of(context).size.height;
    final gridPadding = screenHeight * 0.01;

    return Scaffold(
      body: Column(
        children: [
          const InfoScreen(barheight: 150),
          SizedBox(height: gridPadding),
          Expanded(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(20),
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
          ),
        ],
      ),
    );
  }
}
