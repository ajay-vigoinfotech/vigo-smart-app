import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/team%20view/view/team_view_activity_attendance_list.dart';
import '../view model/team_view_activity_attendance_view_model.dart';

class TeamViewActivityAttendance extends StatefulWidget {
  const TeamViewActivityAttendance({super.key});

  @override
  State<TeamViewActivityAttendance> createState() => _TeamViewActivityAttendanceState();
}

class _TeamViewActivityAttendanceState extends State<TeamViewActivityAttendance> {
  TeamViewActivityAttendanceViewModel teamViewActivityAttendanceViewModel = TeamViewActivityAttendanceViewModel();

  String? userId;
  String? fullName;

  List<Map<String, dynamic>> teamActivityAttendanceCountData = [];
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    // Initially set filteredData to teamActivityAttendanceCountData
    filteredData = teamActivityAttendanceCountData;
    fetchTeamActivityAttendanceCountData(); // Automatically fetch data on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EmployeeSearchDelegate(
                  teamActivityAttendanceCountData: teamActivityAttendanceCountData,
                  onSearch: (searchResult) {
                    setState(() {
                      filteredData = searchResult;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamViewActivityAttendanceList(
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
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
                          title: Text(filteredData[index]['fullName']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchTeamActivityAttendanceCountData() async {
    String? token = await teamViewActivityAttendanceViewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewActivityAttendanceViewModel.fetchTeamActivityAttendanceCount(token);

      if (teamViewActivityAttendanceViewModel.teamActivityAttendanceCount != null) {
        setState(() {
          teamActivityAttendanceCountData = teamViewActivityAttendanceViewModel.teamActivityAttendanceCount!
              .map((entry) => {
            "userId": entry.userId,
            "fullName": entry.fullName,
          })
              .toList();
          filteredData = teamActivityAttendanceCountData;
        });
      }
    }
  }
}

class EmployeeSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> teamActivityAttendanceCountData;
  final Function(List<Map<String, dynamic>>) onSearch;

  EmployeeSearchDelegate({
    required this.teamActivityAttendanceCountData,
    required this.onSearch,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = teamActivityAttendanceCountData
        .where((data) => data['fullName']?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    onSearch(searchResults);
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]['fullName'] ?? 'No Name'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = teamActivityAttendanceCountData
        .where((data) => data['fullName']?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]['fullName'] ?? 'No Name'),
        );
      },
    );
  }
}
