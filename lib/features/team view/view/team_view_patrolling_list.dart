import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_view_patrolling_list_view_model.dart';

class TeamViewPatrollingList extends StatefulWidget {
  const TeamViewPatrollingList({super.key});

  @override
  State<TeamViewPatrollingList> createState() => _TeamViewPatrollingListState();
}

class _TeamViewPatrollingListState extends State<TeamViewPatrollingList> {
  TeamViewPatrollingListViewModel teamViewPatrollingListViewModel = TeamViewPatrollingListViewModel();
  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedState = 'All';
  final List<String> stateOptions = ["All", "Done", "Not Done"];

  List<Map<String, dynamic>> patrollingData = [];
  List<Map<String, dynamic>> filteredPatrollingData = [];

  String? fullName;
  String? counts;
  String? status;

  @override
  void initState() {
    fetchPatrollingListData();
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
        title: const Text('Patrolling List'),
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
                  items: stateOptions.map((String state) {
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
                  onPressed: fetchPatrollingListData,
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
              onRefresh: refreshPatrollingListData,
              child: ListView.builder(
                itemCount: filteredPatrollingData.length,
                itemBuilder: (context, index) {
                  final data = filteredPatrollingData[index];
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

  Future<void> refreshPatrollingListData() async {
    await fetchPatrollingListData();
    debugPrint('Team Patrolling List Data Refreshed');
  }

  Future<void> fetchPatrollingListData() async {
    String? token =
        await teamViewPatrollingListViewModel.sessionManager.getToken();
    if (token != null) {
      await teamViewPatrollingListViewModel.fetchPatrollingList(token);
      if (teamViewPatrollingListViewModel.patrollingList != null) {
        setState(() {
          patrollingData = teamViewPatrollingListViewModel.patrollingList!
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
        filteredPatrollingData = patrollingData;
      } else if (selectedState == "Done") {
        filteredPatrollingData =
            patrollingData.where((entry) => entry['status'] == 'Done').toList();
      } else if (selectedState == "Not Done") {
        filteredPatrollingData = patrollingData
            .where((entry) => entry['status'] == 'Not Done')
            .toList();
      }
    });
  }
}

// fullName = teamViewPatrollingListViewModel.patrollingList![0].fullName;
// counts = teamViewPatrollingListViewModel.patrollingList![0].counts;
// status = teamViewPatrollingListViewModel.patrollingList![0].status;
