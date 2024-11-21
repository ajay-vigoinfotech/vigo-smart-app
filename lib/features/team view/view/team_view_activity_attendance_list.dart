import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_view_activity_attendance_list_view_model.dart';

class TeamViewActivityAttendanceList extends StatefulWidget {
  final String userId;

  const TeamViewActivityAttendanceList({super.key, required this.userId});

  @override
  State<TeamViewActivityAttendanceList> createState() => _TeamViewActivityAttendanceListState();
}

class _TeamViewActivityAttendanceListState extends State<TeamViewActivityAttendanceList> {
  TeamViewActivityAttendanceListViewModel teamViewActivityAttendanceListViewModel = TeamViewActivityAttendanceListViewModel();
  List<Map<String, dynamic>> teamActivityAttendanceData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    fetchTeamViewActivityAttendanceListData();
  }

  Future<void> fetchTeamViewActivityAttendanceListData() async {
    String? token = await teamViewActivityAttendanceListViewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewActivityAttendanceListViewModel.fetchTeamViewActivityAttendanceList(token, widget.userId);

      if (teamViewActivityAttendanceListViewModel.teamActivityAttendanceList != null) {
        setState(() {
          teamActivityAttendanceData = teamViewActivityAttendanceListViewModel
              .teamActivityAttendanceList!
              .map((entry) => {
            "inPhoto": entry.inPhoto,
            "outPhoto": entry.outPhoto,
            "dateTimeIn": entry.dateTimeIn,
            "dateTimeOut": entry.dateTimeOut,
            "location": entry.location,
            "outLocation": entry.outLocation,
            "inRemarks": entry.inRemarks,
            "outRemarks": entry.outRemarks,
          })
              .toList();
          filteredData = teamActivityAttendanceData; // Initialize filtered data
        });
      }
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = teamActivityAttendanceData;
      });
    } else {
      setState(() {
        filteredData = teamActivityAttendanceData.where((entry) {
          final dateTimeIn = entry['dateTimeIn']?.toLowerCase() ?? '';
          final dateTimeOut = entry['dateTimeOut']?.toLowerCase() ?? '';
          final inRemarks = entry['inRemarks']?.toLowerCase() ?? '';
          final outRemarks = entry['outRemarks']?.toLowerCase() ?? '';

          return dateTimeIn.contains(query.toLowerCase()) ||
              dateTimeOut.contains(query.toLowerCase()) ||
              inRemarks.contains(query.toLowerCase()) ||
              outRemarks.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
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
            child: RefreshIndicator(
              onRefresh: refreshTeamActivityAttendanceListData,
              child: filteredData.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final data = filteredData[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildColumn(
                            heading: 'Check In',
                            imageUrl: '${AppConstants.baseUrl}/${data["inPhoto"]}',
                            dateTime: data["dateTimeIn"],
                            borderColor: Colors.green,
                            location: data["location"],
                            headingColor: Colors.green,
                            remark: data["inRemarks"]
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            thickness: 1,
                            width: 10,
                          ),
                          _buildColumn(
                            heading: 'Check Out',
                            imageUrl: '${AppConstants.baseUrl}/${data["outPhoto"]}',
                            dateTime: data["dateTimeOut"],
                            borderColor: Colors.redAccent,
                            location: data["outLocation"],
                            headingColor: Colors.redAccent,
                              remark: data["outRemarks"]
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No records found',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshTeamActivityAttendanceListData() async {
    await fetchTeamViewActivityAttendanceListData();
    debugPrint('Team Activity Attendance List Data Refreshed');
  }

  Widget _buildColumn({
    required String heading,
    required String imageUrl,
    required String? dateTime,
    required String? location,
    required Color borderColor,
    required Color headingColor,
    required String? remark,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyle(
                color: headingColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(thickness: 2, color: Colors.black26),
            SizedBox(
              height: 100,
              width: 100,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/place_holder.webp'),
              )
                  : Image.asset('assets/images/place_holder.webp'),
            ),
            const SizedBox(height: 8),
            Text(
              (dateTime ?? '').isNotEmpty ? dateTime! : 'Not marked yet',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              location?.split('&').first ?? 'N/A',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 4),
            Text(
              remark!,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content:
          const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
