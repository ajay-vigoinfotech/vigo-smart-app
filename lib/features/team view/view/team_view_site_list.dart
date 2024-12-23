import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_view_site_list_view_model.dart';

class TeamViewSiteList extends StatefulWidget {
  const TeamViewSiteList({super.key});

  @override
  State<TeamViewSiteList> createState() => _TeamViewSiteListState();
}

class _TeamViewSiteListState extends State<TeamViewSiteList> {

  TeamViewSiteListViewModel teamViewSiteListViewModel = TeamViewSiteListViewModel();
  String selectedDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());
  String selectedState = "All";
  final List<String> stateOption = ["All", "Done", "Not Done"];

  List<Map<String, dynamic>> siteData = [];
  List<Map<String, dynamic>> filteredSiteData = [];

  String? fullName;
  String? counts;
  String? status;


  @override
  void initState() {
    fetchSiteListData();
    checkInternetConnection();
    super.initState();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 5),
                    Text(
                      selectedDate,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedState,
                  items: stateOption.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (newState) {
                    setState(() {
                      selectedState = newState!;
                      // applyFilter();
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 5,
                  ),
                  onPressed: fetchSiteListData,
                  child: const Text('Search',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.blue,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(3.0),
                2: FlexColumnWidth(1.0),
                3: FlexColumnWidth(1.5),
              },
              children: const [
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Text(
                          "Sr",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "Employee Name",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "Count",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          "Status",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshSiteListData,
              child: ListView.builder(
                itemCount: filteredSiteData.length,
                itemBuilder: (context, index) {
                  final data = filteredSiteData[index];
                  return Card(
                    elevation: 3,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(0.5),
                            1: FlexColumnWidth(3.0),
                            2: FlexColumnWidth(1.0),
                            3: FlexColumnWidth(1.5),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      "${data['fullName'] ?? "N/A"}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      (data['counts'] ?? "N/A").toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      data['status'] ?? "N/A",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: data['status'] == "Done"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  Future<void> refreshSiteListData() async {
    await fetchSiteListData();
    debugPrint('Site List Data Refreshed');
  }

  Future<void> fetchSiteListData() async {
    String? token = await teamViewSiteListViewModel.sessionManager.getToken();
    if (token != null) {
      await teamViewSiteListViewModel.fetchSitList(token);
      if (teamViewSiteListViewModel.siteList != null) {
        setState(() {
          siteData = teamViewSiteListViewModel.siteList!
              .map((entry) => {
            "fullName": entry.fullName,
            "counts": entry.counts,
            "status": entry.status,
          })
              .toList();
          applyFilter();
        });
      }
    }
  }

  void applyFilter() {
    setState(() {
      if (selectedState == "All") {
        filteredSiteData = siteData;
      } else if (selectedState == "Done") {
        filteredSiteData = siteData.where((entry) => entry['status'] == 'Done').toList();
      } else if (selectedState == "Not Done") {
        filteredSiteData = siteData
            .where((entry) => entry['status'] == 'Not Done')
            .toList();
      }
    });
  }
}

