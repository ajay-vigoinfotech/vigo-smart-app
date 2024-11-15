import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_view_attendance_list_view_model.dart';

class TeamViewAttendanceList extends StatefulWidget {
  const TeamViewAttendanceList({super.key});

  @override
  State<TeamViewAttendanceList> createState() => _TeamViewAttendanceListState();
}

class _TeamViewAttendanceListState extends State<TeamViewAttendanceList> {
  final TeamViewAttendanceListViewModel teamViewAttendanceListViewModel = TeamViewAttendanceListViewModel();
  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedState = "All";
  final List<String> stateOptions = ["All", "Present", "Absent", "Late"];

  List<Map<String, dynamic>> attendanceData = [];
  List<Map<String, dynamic>> filteredAttendanceData = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
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
                  TextButton(
                    onPressed: fetchAttendanceListData,
                    child: const Text('Search'),
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
                  0: FlexColumnWidth(0.3),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(0.5),
                  3: FlexColumnWidth(0.5),
                  4: FlexColumnWidth(0.5),
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
                            "In",
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
                            "Out",
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
                onRefresh: refreshTeamAttendanceListData,
                child: ListView.builder(
                  itemCount: filteredAttendanceData.length,
                  itemBuilder: (context, index) {
                    final data = filteredAttendanceData[index];
                    return Card(
                      elevation: 3,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(0.3),
                              1: FlexColumnWidth(1.5),
                              2: FlexColumnWidth(0.5),
                              3: FlexColumnWidth(0.5),
                              4: FlexColumnWidth(0.5),
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
                                        (data['dateTimeIn'] ?? "N/A").toString(),
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
                                        (data['dateTimeOut'] ?? "N/A").toString(),
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
      ),
    );
  }

  Future<void> refreshTeamAttendanceListData() async {
    await fetchAttendanceListData();
    debugPrint('Team Attendance List Data Refreshed');
  }

  Future<void> fetchAttendanceListData() async {
    String? token = await teamViewAttendanceListViewModel.sessionManager.getToken();
    if (token != null) {
      await teamViewAttendanceListViewModel.fetchAttendanceList(token);

      if (teamViewAttendanceListViewModel.attendanceList != null) {
        setState(() {
          attendanceData = teamViewAttendanceListViewModel.attendanceList!
              .map((entry) => {
            "fullName": entry.fullName,
            "dateTimeIn": entry.dateTimeIn,
            "dateTimeOut": entry.dateTimeOut,
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
        filteredAttendanceData = attendanceData;
      } else if (selectedState == "Present") {
        filteredAttendanceData = attendanceData.where((entry) => entry['status'] == 'P').toList();
      } else if (selectedState == "Absent") {
        filteredAttendanceData = attendanceData.where((entry) => entry['status'] == 'A').toList();
      } else if (selectedState == "Late") {
        filteredAttendanceData = attendanceData.where((entry) => entry['status'] == 'L').toList();
      }
    });
  }
}



