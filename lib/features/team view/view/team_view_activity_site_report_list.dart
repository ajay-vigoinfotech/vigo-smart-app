import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/previous_site_reporting_list.dart';

import '../view model/team_view_activity_site_report_list_view_model.dart';

class TeamViewActivitySiteReportList extends StatefulWidget {
  final dynamic userId;

  const TeamViewActivitySiteReportList({super.key, required this.userId});

  @override
  State<TeamViewActivitySiteReportList> createState() =>
      _TeamViewActivitySiteReportListState();
}

class _TeamViewActivitySiteReportListState
    extends State<TeamViewActivitySiteReportList> {
  TeamViewActivitySiteReportListViewModel
      teamViewActivitySiteReportListViewModel =
      TeamViewActivitySiteReportListViewModel();

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> teamActivitySieReportListData = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    fetchTeamViewActivitySiteReportListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Site Reporting'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResult,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: refreshTeamViewActivitySiteReportListData,
                    child: filteredData.isEmpty
                        ? const Center(child: Text('No Data available'))
                        : ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PreviousSiteReportingList(
                                              checkinId: filteredData[index]
                                                  ['checkinId']),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.all(8.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildCard(
                                          time:
                                              data['dateTimeIn'].split(' ')[0],
                                          date:
                                              data['dateTimeIn'].split(' ')[3],
                                          unitName: data['unitName'],
                                          checkinTypeName:
                                              data['checkinTypeName'],
                                          inRemarks: data['inRemarks'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String time,
    required String date,
    required String unitName,
    required String checkinTypeName,
    required String inRemarks,
  }) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  time,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Site Name : ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                    child: Text(
                  unitName,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Name : ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Flexible(
                  child: Text(checkinTypeName),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remarks : ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(child: Text(inRemarks))
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<void> fetchTeamViewActivitySiteReportListData() async {
    String? token =
        await teamViewActivitySiteReportListViewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewActivitySiteReportListViewModel
          .fetchTeamViewActivitySiteReportList(token, widget.userId);

      if (teamViewActivitySiteReportListViewModel.teamActivitySiteReportList !=
          null) {
        setState(() {
          teamActivitySieReportListData =
              teamViewActivitySiteReportListViewModel
                  .teamActivitySiteReportList!
                  .map((entry) => {
                        "checkinId": entry.checkinId,
                        "compId": entry.compId,
                        "userId": entry.userId,
                        "checkinTypeName": entry.checkinTypeName,
                        "clientSiteId": entry.clientSiteId,
                        "unitName": entry.unitName,
                        "inRemarks": entry.inRemarks,
                        "dateTimeIn": entry.dateTimeIn,
                      })
                  .toList();
          filteredData = teamActivitySieReportListData;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> refreshTeamViewActivitySiteReportListData() async {
    await fetchTeamViewActivitySiteReportListData();
    debugPrint('teamActivitySieReportListData Data Refreshed');
  }

  void filterSearchResult(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredData = teamActivitySieReportListData;
      });
    } else {
      setState(() {
        filteredData = teamActivitySieReportListData.where((entry) {
          final checkinId = entry['checkinId']?.toLowerCase() ?? '';
          final compId = entry['compId']?.toLowerCase() ?? '';
          final userId = entry['userId']?.toLowerCase() ?? '';
          final checkinTypeName = entry['checkinTypeName']?.toLowerCase() ?? '';
          final clientSiteId = entry['clientSiteId']?.toLowerCase() ?? '';
          final unitName = entry['unitName']?.toLowerCase() ?? '';
          final inRemarks = entry['inRemarks']?.toLowerCase() ?? '';
          final dateTimeIn = entry['dateTimeIn']?.toLowerCase() ?? '';

          return checkinId.contains(query.toLowerCase()) ||
              compId.contains(query.toLowerCase()) ||
              userId.contains(query.toLowerCase()) ||
              checkinTypeName.contains(query.toLowerCase()) ||
              clientSiteId.contains(query.toLowerCase()) ||
              unitName.contains(query.toLowerCase()) ||
              inRemarks.contains(query.toLowerCase()) ||
              dateTimeIn.contains(query.toLowerCase());
        }).toList();
      });
    }
  }
}
