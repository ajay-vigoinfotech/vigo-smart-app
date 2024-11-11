import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';

import '../view model/team_dashboard_count_view_model.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final TeamDashboardCountViewModel _viewModel = TeamDashboardCountViewModel();
  bool _isLoading = true;
  String? _errorMessage;

  int? employeeCount;
  int? presentEmployeeCount;
  int? absentEmployeeCount;
  int? lateEmployeeCount;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    String? token = await _viewModel.sessionManager.getToken();

    if (token != null) {
      await _viewModel.fetchTeamDashboardCount(token);

      if (_viewModel.teamDashboardCount != null) {
        setState(() {
          employeeCount = _viewModel.teamDashboardCount?.employeeCount;
          presentEmployeeCount = _viewModel.teamDashboardCount?.presentEmployeeCount;
          absentEmployeeCount = _viewModel.teamDashboardCount?.absentEmployeeCount;
          lateEmployeeCount = _viewModel.teamDashboardCount?.lateEmployeeCount;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Authorization token not found';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(Strings.teamViewApp),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('DASHBOARD'),
              ),
              Tab(
                child: Text('TEAM ACTIVITY'),
              ),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            Column(
              children: [
            buildCard('Attendance', 'Total EMP', '5', Colors.blue, 'PRESENT', '4', Colors.green),
              ],
            ),
            Center(
              child: Text("2nd tab view"),
            ),
          ],
        ),
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(Strings.teamViewApp),
  //     ),
  //     body: _isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : _errorMessage != null
  //         ? Center(child: Text(_errorMessage!))
  //         : Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // _buildInfoRow("Employee Count:", employeeCount),
  //           // _buildInfoRow("Present Employee Count:", presentEmployeeCount),
  //           // _buildInfoRow("Absent Employee Count:", absentEmployeeCount),
  //           // _buildInfoRow("Late Employee Count:", lateEmployeeCount),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildInfoRow(String title, int? value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(title, style: const TextStyle(fontSize: 16)),
  //         Text(value != null ? value.toString() : '-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //       ],
  //     ),
  //   );
  // }



  Widget buildCard(String title, String label1, String value1, Color color1, String label2, String value2, Color color2) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    label1,
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value1,
                    style: TextStyle(fontSize: 16, color: color1),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    label2,
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value2,
                    style: TextStyle(fontSize: 16, color: color2),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'LATE',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '4', // Example data
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'ABSENT',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '4', // Example data
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Check List'),
                Icon(Icons.arrow_right_alt),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
