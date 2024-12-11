import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';

import '../view model/leave_balance_view_model.dart';
import '../view model/leave_history_view_model.dart';

class LeaveManagement extends StatefulWidget {
  const LeaveManagement({super.key});

  @override
  State<LeaveManagement> createState() => _LeaveManagementState();
}

class _LeaveManagementState extends State<LeaveManagement> {
  LeaveBalanceViewModel leaveBalanceViewModel = LeaveBalanceViewModel();
  List<Map<String, dynamic>> leavesBalanceListData = [];
  List<Map<String, dynamic>> leavesNameListData = [];

  LeaveHistoryViewModel leaveHistoryViewModel = LeaveHistoryViewModel();
  List<Map<String, dynamic>> leaveHistoryListData = [];

  @override
  void initState() {
    fetchEmployeeLeavesData();
    fetchLeaveHistoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.leaveMgmtApp),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Leave Balance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: leavesBalanceListData.isEmpty
                  ? [const Center(child: CircularProgressIndicator())]
                  : leavesBalanceListData.map((leave) {
                      // Find matching leaveName from table1
                      final matchingLeaveName = leavesNameListData.firstWhere(
                        (leaveName) => leaveName['leaveId'] == leave['leaveId'],
                        orElse: () => <String, String?>{},
                      );
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          // color: Colors.white,
                          elevation: 5,
                          child: Container(
                            decoration: const BoxDecoration(),
                            width: 170,
                            height: 170,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${leave['totalLeaves']}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 75,
                                  child: Text(
                                    matchingLeaveName.isNotEmpty
                                        ? '${matchingLeaveName['leaveName'] ?? ''}'
                                        : '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Leave History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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

  Future<void> fetchLeaveHistoryData() async {
    String? token = await leaveHistoryViewModel.sessionManager.getToken();
    if (token != null) {
      await leaveHistoryViewModel.fetchLeaveHistory(token);

      setState(() {
        if (leaveHistoryViewModel.leaveHistoryList != null) {
          leaveHistoryListData = leaveHistoryViewModel.leaveHistoryList!
              .map((entry) => {
                    "employeesLeaveId": entry.employeesLeaveId,
                    "userId": entry.userId,
                    "employeeCode": entry.employeeCode,
                    "fullName": entry.fullName,
                    "leaveEnableDisable": entry.leaveEnableDisable,
                    "leavePendingApprove": entry.leavePendingApprove,
                    "leaveType": entry.leaveType,
                    "dateFrom": entry.dateFrom,
                    "dateTo": entry.dateTo,
                    "remark": entry.remark,
                    "createdAt": entry.createdAt,
                    "createdBy": entry.createdBy,
                    "leavesListId": entry.leavesListId,
                    "noOfDays": entry.noOfDays,
                  })
              .toList();
        }
      });
    }
  }
}
