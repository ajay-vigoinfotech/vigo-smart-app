import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/previous_site_reporting_list.dart';

import '../view model/get_site_visit_list_view_model.dart';

class SiteReportingDetails extends StatefulWidget {
  const SiteReportingDetails({super.key});

  @override
  State<SiteReportingDetails> createState() => _SiteReportingDetailsState();
}

class _SiteReportingDetailsState extends State<SiteReportingDetails> {
  GetSiteVisitListViewModel getSiteVisitListViewModel =
      GetSiteVisitListViewModel();

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> siteVisitList = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    checkInternetConnection();
    fetchGetSiteVisitListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Reporting Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search here",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: refreshGetSiteVisitListData,
                    child: filteredData.isEmpty
                        ? const Center(child: Text('No data available'))
                        : ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => PreviousSiteReportingList(
                                        checkinId: filteredData[index]['checkinId'],
                                      )));

                                  debugPrint('Card tapped');
                                },
                                child: Card(
                                  //color: Colors.white,
                                  margin: const EdgeInsets.all(8.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildCard(
                                          time: data['dateTimeIn'].split(' ')[0],
                                          date: data['dateTimeIn'].split(' ')[3],
                                          unitName: data['unitName'],
                                          checkinTypeName: data['checkinTypeName'],
                                          inRemarks: data['inRemarks'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Show dialog to ask user to turn on internet connection
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content:
          const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
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
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
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
                ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      unitName,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.visible,
                    ),
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
                    'Activity Name : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      checkinTypeName,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.visible,
                    ),
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
                    'Remark : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      inRemarks,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchGetSiteVisitListData() async {
    String? token = await getSiteVisitListViewModel.sessionManager.getToken();
    if (token != null) {
      await getSiteVisitListViewModel.fetchGetSiteVisitList(token);

      if (getSiteVisitListViewModel.getSiteVisitList != null) {
        setState(() {
          siteVisitList = getSiteVisitListViewModel.getSiteVisitList!
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
          filteredData = siteVisitList;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = siteVisitList;
      });
    } else {
      setState(() {
        filteredData = siteVisitList.where((entry) {
          final dateTimeIn = entry['dateTimeIn']?.toLowerCase() ?? '';
          final unitName = entry['unitName']?.toLowerCase() ?? '';
          final inRemarks = entry['inRemarks']?.toLowerCase() ?? '';
          final clientSiteId = entry['clientSiteId']?.toLowerCase() ?? '';
          final checkinTypeName = entry['checkinTypeName']?.toLowerCase() ?? '';

          return dateTimeIn.contains(query.toLowerCase()) ||
              inRemarks.contains(query.toLowerCase()) ||
              unitName.contains(query.toLowerCase()) ||
              clientSiteId.contains(query.toLowerCase()) ||
              checkinTypeName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> refreshGetSiteVisitListData() async {
    await fetchGetSiteVisitListData();
    debugPrint('GetSiteVisitListData Data Refreshed');
  }
}
