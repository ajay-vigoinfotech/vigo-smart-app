import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_view_attendance_list_view_model.dart';

class TeamViewAttendanceList extends StatefulWidget {
  const TeamViewAttendanceList({super.key});

  @override
  State<TeamViewAttendanceList> createState() => _TeamViewAttendanceListState();
}

class _TeamViewAttendanceListState extends State<TeamViewAttendanceList> {
  String? fullName;
  String? userId;
  String? dateTimeIn;
  String? dateTimeOut;
  String? status;

  final TeamViewAttendanceListViewModel teamViewAttendanceListViewModel = TeamViewAttendanceListViewModel();

  // New variables for filters
  String selectedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  String selectedState = "All"; // Default filter state
  final List<String> stateOptions = ["All", "Present", "Absent", "Late"];

  @override
  void initState() {
    super.initState();
    fetchAttendanceListData(); // Fetch initial data when the screen loads
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
            // Row for filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filter by Date
                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    Text(
                      selectedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                // Filter by State dropdown
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
                    });
                  },
                ),

                // Search button
                TextButton(
                  onPressed: () {
                    fetchAttendanceListData();
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List view to display attendance data
            Expanded(
              child: ListView(
                children: [
                  // Display fetched attendance data here
                  if (fullName != null) ...[
                    Text("Name: $fullName"),
                    Text("User ID: $userId"),
                    Text("In Time: $dateTimeIn"),
                    Text("Out Time: $dateTimeOut"),
                    Text("Status: $status"),
                  ] else
                    const Center(child: Text("No data available")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAttendanceListData() async {
    String? token = await teamViewAttendanceListViewModel.sessionManager.getToken();
    if (token != null) {
      await teamViewAttendanceListViewModel.fetchAttendanceList(token);

      if (teamViewAttendanceListViewModel.attendanceList != null) {
        setState(() {
          fullName = teamViewAttendanceListViewModel.attendanceList?.fullName;
          userId = teamViewAttendanceListViewModel.attendanceList?.userId;
          dateTimeIn = teamViewAttendanceListViewModel.attendanceList?.dateTimeIn;
          dateTimeOut = teamViewAttendanceListViewModel.attendanceList?.dateTimeOut;
          status = teamViewAttendanceListViewModel.attendanceList?.status;
        });
      }
    }
  }
}
