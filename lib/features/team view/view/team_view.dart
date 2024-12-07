import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_dashboard_field_count_view_model.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_dashboard_site_count_view_model.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_activity_attendance.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_activity_patrolling.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_activity_site_report.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_attendance_list.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_patrolling_list.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_site_list.dart';

import '../../../core/theme/app_pallete.dart';
import '../../home/widgets/home_screen_card.dart';
import '../view model/team_dashboard_count_view_model.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final TeamViewDashBoardSiteCountViewModel teamViewDashBoardSiteCountViewModel = TeamViewDashBoardSiteCountViewModel();
  final TeamViewDashBoardFieldCountViewModel teamViewDashBoardFieldCountViewModel = TeamViewDashBoardFieldCountViewModel();
  final TeamDashboardCountViewModel viewModel = TeamDashboardCountViewModel();
  String? _errorMessage;

  int employeeCount = 0;
  int presentEmployeeCount = 0;
  int absentEmployeeCount = 0;
  int lateEmployeeCount = 0;

  int employeeSiteVisitCount = 0;
  int employeeSiteNotVisitCount = 0;

  int employeeFieldVisitCount = 0;
  int employeeFieldNotVisitCount = 0;

  List<String> savedModules = [];


  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _fetchSiteDashboardData();
    _fetchFieldDashboardData();
    _loadModules();
  }

  Future<void> _loadModules() async {
    SessionManager sessionManager = SessionManager();
    savedModules = await sessionManager.getModuleCodes() ?? [];
    debugPrint('Saved Modules ::$savedModules');
    setState(() {});
  }

  bool hasAttendanceModule() {
    const requiredModules = [
      'SupervisorDutyManagementApp',
      'SupervisorQRDutyManagementApp',
      'DutyManagementApp',
      'DutyManagementAppQR',
    ];
    return savedModules.any(requiredModules.contains);
  }

  bool hasFieldModule() {
    const requiredModules = [
      'FieldReportingApp',
      'FieldReportingQRApp'
    ];
    return savedModules.any(requiredModules.contains);
  }
  bool hasSiteModule() {
    const requiredModules = [
      'SiteReportingApp',
      'SiteReportingQRApp'
    ];
    return savedModules.any(requiredModules.contains);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.teamViewApp),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('DASHBOARD'),
              ),
              Tab(
                child: Text('TEAM ACTIVITY'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: _refreshTeamViewData,
              child: ListView(
                children: [
                  buildCard(
                    'Attendance',
                    {
                      'Total Emp': {'count': employeeCount, 'color': Colors.blue},
                      'PRESENT': {'count': presentEmployeeCount, 'color': Colors.green},
                      'LATE': {'count': absentEmployeeCount, 'color': Colors.blueGrey},
                      'ABSENT': {'count': lateEmployeeCount, 'color': Colors.red},
                    },
                    {'Check List': const TeamViewAttendanceList()},
                  ),
                  buildCard(
                    'Patrolling',
                    {
                      'Total Emp': {'count': employeeCount, 'color': Colors.blue},
                      'Done': {'count': employeeFieldVisitCount, 'color': Colors.green},
                      'Not Done': {'count': employeeFieldNotVisitCount, 'color': Colors.red},
                    },
                    {'Check List': const TeamViewPatrollingList()},
                  ),
                  buildCard(
                    'Site Reporting',
                    {
                      'Total Emp': {'count': employeeCount, 'color': Colors.blue},
                      'Done': {'count': employeeSiteVisitCount, 'color': Colors.green},
                      'Not Done': {'count': employeeSiteNotVisitCount, 'color': Colors.red},
                    },
                    {'Check List': const TeamViewSiteList()},
                  ),
                ],
              ),
            ),
            ListView(
              children: [
                if (hasAttendanceModule())
                  HomeScreenCard(
                    icon: Image.asset('assets/images/attendance_new.webp'),
                    modulename: 'Attendance',
                    nextPage: const TeamViewActivityAttendance(),
                    cardColor: Pallete.backgroundColor,
                  ),
                if (hasFieldModule())
                  HomeScreenCard(
                    icon: Image.asset('assets/images/patrolling.webp'),
                    modulename: 'Patrolling',
                    nextPage: const TeamViewActivityPatrolling(),
                    cardColor: Pallete.backgroundColor,
                  ),
                if (hasSiteModule())
                  HomeScreenCard(
                    icon: Image.asset('assets/images/site_reporting.webp'),
                    modulename: 'Site Report',
                    nextPage: const TeamViewActivitySiteReport(),
                    cardColor: Pallete.backgroundColor,
                  ),
                // HomeScreenCard(
                //     icon: Image.asset('assets/images/ic_maps.webp'),
                //     modulename: 'Map View',
                //     nextPage: const SettingPage(),
                //     cardColor: Pallete.backgroundColor,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
      String title, Map<String, dynamic> fields, Map<String, Widget> pages) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: fields.entries.map((entry) {
              final label = entry.key;
              final value = entry.value['count'];
              final color = entry.value['color'];

              return Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          const Divider(),
          Wrap(
            spacing: 8.0,
            children: pages.entries.map((entry) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => entry.value),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.key),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Future<void> _refreshTeamViewData() async {
    await _fetchDashboardData();
    await _fetchSiteDashboardData();
    await _fetchFieldDashboardData();
    debugPrint('Team View Data Refreshed');
  }

  Future<void> _fetchFieldDashboardData() async {
    String? token = await viewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewDashBoardFieldCountViewModel.fetchFieldDashboardCount(token);

      if (teamViewDashBoardFieldCountViewModel.fieldDashBoardCount != null) {
        setState(() {
          employeeFieldVisitCount = teamViewDashBoardFieldCountViewModel.fieldDashBoardCount?.employeeFieldVisitCount ?? 0;
          employeeFieldNotVisitCount = teamViewDashBoardFieldCountViewModel.fieldDashBoardCount?.employeeFieldNotVisitCount ?? 0;
          employeeCount = teamViewDashBoardSiteCountViewModel.siteDashBoardCount?.employeeCount ?? 0;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Authorization token not found';
      });
    }
  }

  Future<void> _fetchSiteDashboardData() async {
    String? token = await viewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewDashBoardSiteCountViewModel.fetchSiteDashboardCount(token);

      if (teamViewDashBoardSiteCountViewModel.siteDashBoardCount != null) {
        setState(() {
          employeeSiteVisitCount = teamViewDashBoardSiteCountViewModel.siteDashBoardCount?.employeeSiteVisitCount ?? 0;
          employeeSiteNotVisitCount = teamViewDashBoardSiteCountViewModel.siteDashBoardCount?.employeeSiteNotVisitCount ?? 0;
          employeeCount = teamViewDashBoardSiteCountViewModel.siteDashBoardCount?.employeeCount ?? 0;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Authorization token not found';
      });
    }
  }

  Future<void> _fetchDashboardData() async {
    String? token = await viewModel.sessionManager.getToken();

    if (token != null) {
      await viewModel.fetchTeamDashboardCount(token);

      if (viewModel.teamDashboardCount != null) {
        setState(() {
          employeeCount = viewModel.teamDashboardCount?.employeeCount ?? 0;
          presentEmployeeCount = viewModel.teamDashboardCount?.presentEmployeeCount ?? 0;
          absentEmployeeCount = viewModel.teamDashboardCount?.absentEmployeeCount ?? 0;
          lateEmployeeCount = viewModel.teamDashboardCount?.lateEmployeeCount ?? 0;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Authorization token not found';
      });
    }
  }
}
