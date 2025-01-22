import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/recruitment/view/active_employee_details.dart';

import '../view model/team_view_activity_emp_recruitment_list_view_model.dart';

class TeamViewActivityRecruitmentReportList extends StatefulWidget {
  final dynamic userId;
  const TeamViewActivityRecruitmentReportList({super.key, required this.userId});

  @override
  State<TeamViewActivityRecruitmentReportList> createState() => _TeamViewActivityRecruitmentReportListState();
}

class _TeamViewActivityRecruitmentReportListState extends State<TeamViewActivityRecruitmentReportList> {
  TeamViewActivityEmpRecruitmentListViewModel teamViewActivityEmpRecruitmentListViewModel = TeamViewActivityEmpRecruitmentListViewModel();
  List<Map<String, dynamic>> teamActivityEmpRecruitmentData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;


  @override
  void initState() {
    fetchTeamViewActivityEmpRecruitmentListData();
    checkInternetConnection();
    super.initState();
  }

  Future<void> fetchTeamViewActivityEmpRecruitmentListData() async {
    setState(() {
      isLoading = true;
    });
    String? token = await teamViewActivityEmpRecruitmentListViewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewActivityEmpRecruitmentListViewModel.fetchTeamViewActivityEmpRecruitmentList(token, widget.userId);

      if (teamViewActivityEmpRecruitmentListViewModel.teamActivityEmpRecruitmentList != null) {
        setState(() {
          teamActivityEmpRecruitmentData = teamViewActivityEmpRecruitmentListViewModel
              .teamActivityEmpRecruitmentList!
              .map((entry) => {
            "userId": entry.userId,
            "fullName": entry.fullName,
          })
              .toList();
          filteredData = teamActivityEmpRecruitmentData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = teamActivityEmpRecruitmentData;
      });
    } else {
      setState(() {
        filteredData = teamActivityEmpRecruitmentData.where((entry) {
          final userId = entry['userId']?.toLowerCase() ?? '';
          final fullName = entry['fullName']?.toLowerCase() ?? '';
          return userId.contains(query.toLowerCase()) ||
              fullName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruited Employee List'),
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchTeamViewActivityEmpRecruitmentListData,
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
                              ActiveEmployeeDetails(
                                 recruitedUserId: filteredData[index]['userId'],
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
}
