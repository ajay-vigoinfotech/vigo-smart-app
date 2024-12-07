import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_activity_site_report_list.dart';

import '../view model/team_view_activity_attendance_view_model.dart';

class TeamViewActivitySiteReport extends StatefulWidget {
  const TeamViewActivitySiteReport({super.key});

  @override
  State<TeamViewActivitySiteReport> createState() =>
      _TeamViewActivitySiteReportState();
}

class _TeamViewActivitySiteReportState
    extends State<TeamViewActivitySiteReport> {
  TeamViewActivityAttendanceViewModel teamViewActivityAttendanceViewModel =
      TeamViewActivityAttendanceViewModel();

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> teamViewActivitySiteReportCountData = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    fetchTeamActivityAttendanceCountData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Names'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: searchController,
            onChanged: filterSearchResult,
            decoration: InputDecoration(
              hintText: "Search Employee",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: refreshTeamActivitySiteReportData,
                  child: filteredData.isEmpty
                      ? Center(child: Text('No Data Available'))
                      : ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TeamViewActivitySiteReportList(
                                      userId: filteredData[index]['userId'],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 8.0,
                                      color: Colors.orange,
                                    ),
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      title:
                                          Text(filteredData[index]['fullName']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ),
      ]),
    );
  }

  Future<void> refreshTeamActivitySiteReportData() async {
    await fetchTeamActivityAttendanceCountData();
    // debugPrint('Team Activity Attendance List Data Refreshed');
  }

  Future<void> fetchTeamActivityAttendanceCountData() async {
    String? token =
        await teamViewActivityAttendanceViewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewActivityAttendanceViewModel
          .fetchTeamActivityAttendanceCount(token);

      if (teamViewActivityAttendanceViewModel.teamActivityAttendanceCount !=
          null) {
        setState(() {
          teamViewActivitySiteReportCountData =
              teamViewActivityAttendanceViewModel.teamActivityAttendanceCount!
                  .map((entry) => {
                        "userId": entry.userId,
                        "fullName": entry.fullName,
                      })
                  .toList();
          filteredData = teamViewActivitySiteReportCountData;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void filterSearchResult(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredData = teamViewActivitySiteReportCountData;
      });
    } else {
      setState(() {
        filteredData = teamViewActivitySiteReportCountData.where((entry) {
          final userId = entry['userId']?.toLowerCase() ?? '';
          final fullName = entry['fullName']?.toLowerCase() ?? '';

          return userId.contains(query.toLowerCase()) ||
              fullName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }
}
