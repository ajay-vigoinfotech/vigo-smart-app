import 'package:flutter/material.dart';
import '../view model/leave_balance_view_model.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  LeaveBalanceViewModel leaveBalanceViewModel = LeaveBalanceViewModel();
  List<Map<String, dynamic>> leavesBalanceListData = [];
  List<Map<String, dynamic>> leavesNameListData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEmployeeLeavesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Select Leave Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: StatefulBuilder(
                        builder: (context, setState) => SizedBox(
                          height: 400,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'Designation',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              // Search Field
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    setState(
                                        () {}); // Triggers UI refresh on search input change
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children:
                                      leavesBalanceListData.where((leave) {
                                    final matchingLeaveName =
                                        leavesNameListData.firstWhere(
                                      (leaveName) =>
                                          leaveName['leaveId'] ==
                                          leave['leaveId'],
                                      orElse: () => <String, String?>{},
                                    );
                                    final leaveName =
                                        matchingLeaveName['leaveName'] ??
                                            'null';
                                    return leaveName.toLowerCase().contains(
                                        searchController.text.toLowerCase());
                                  }).map((leave) {
                                    final matchingLeaveName =
                                        leavesNameListData.firstWhere(
                                      (leaveName) =>
                                          leaveName['leaveId'] ==
                                          leave['leaveId'],
                                      orElse: () => <String, String?>{},
                                    );
                                    return ListTile(
                                      title: Text(
                                        '${matchingLeaveName['leaveName'] ?? 'null'} (${leave['totalLeaves']})',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Handle the selection logic if needed
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Select Leave Type'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Select Duration Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchEmployeeLeavesData() async {
    String? token = await leaveBalanceViewModel.sessionManager.getToken();
    if (token != null) {
      await leaveBalanceViewModel.fetchEmployeeLeaves(token);

      setState(() {
        if (leaveBalanceViewModel.leavesBalanceList != null) {
          leavesBalanceListData = leaveBalanceViewModel.leavesBalanceList!
              .map((entry) => {
                    "userId": entry.userId,
                    "leaveId": entry.leaveId,
                    "totalLeaves": entry.totalLeaves,
                  })
              .toList();
        }

        if (leaveBalanceViewModel.leaveNameList != null) {
          leavesNameListData = leaveBalanceViewModel.leaveNameList!
              .map((entry) => {
                    "leaveId": entry.leaveId,
                    "shortCode": entry.shortCode,
                    "leaveName": entry.leaveName,
                    "leaveId1": entry.leaveId1,
                    "yearIdFrom": entry.yearIdFrom,
                    "monthIdFrom": entry.monthIdFrom,
                    "yearTo": entry.yearTo,
                    "monthIdTo": entry.monthIdTo,
                    "yearlyLeave": entry.yearlyLeave,
                    "monthlyLeave": entry.monthlyLeave,
                    "totalYearlyLeave": entry.totalYearlyLeave,
                    "totalMonthlyLeave": entry.totalMonthlyLeave,
                    "carryForword": entry.carryForword,
                  })
              .toList();
        }
      });
    }
  }
}

