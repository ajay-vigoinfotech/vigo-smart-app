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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 5), // Add spacing between icon and text
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
                      //applyFilter();
                    });
                  },
                ),
                TextButton(
                  onPressed: fetchAttendanceListData,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // Responsive Header Row with Adjusted Flex
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text("Sr",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  Expanded(
                      flex: 5,
                      child: Text("Employee Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  Expanded(
                      flex: 3,
                      child: Text("In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  Expanded(
                      flex: 3,
                      child: Text("Out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  Expanded(
                      flex: 2, // Reduced flex for Status
                      child: Text("Status",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshTeamAttendanceListData,
                child: ListView.builder(
                  itemCount: filteredAttendanceData.length,
                  itemBuilder: (context, index) {
                    final data = filteredAttendanceData[index];
                    return SizedBox(
                      height: 70,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(flex: 1, child: Text("${index + 1}")),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  "${data['fullName'] ?? "N/A"}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Text(data['dateTimeIn'] ?? "N/A")),
                              Expanded(
                                  flex: 3,
                                  child: Text(data['dateTimeOut'] ?? "N/A")),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    data['status'] ?? "N/A",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: data['status'] == "Present"
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  )),
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

  Future<void> _refreshTeamAttendanceListData() async {
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
