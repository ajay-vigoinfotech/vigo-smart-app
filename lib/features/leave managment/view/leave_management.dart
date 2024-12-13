import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';
import 'package:vigo_smart_app/features/leave%20managment/view/apply_leave.dart';

import '../view model/leave_balance_view_model.dart';
import '../view model/leave_cancel_view_model.dart';
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
  bool isLoading = true;

  LeaveCancelViewModel leaveCancelViewModel = LeaveCancelViewModel();

  @override
  void initState() {
    fetchEmployeeLeavesData();
    fetchLeaveHistoryData();
    super.initState();
  }

  Future<void> refreshLeaveManagementData() async {
    await fetchEmployeeLeavesData();
    await fetchLeaveHistoryData();
    debugPrint('refreshLeaveManagementData Refreshed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.leaveMgmtApp),
      ),
      body: RefreshIndicator(
        onRefresh: refreshLeaveManagementData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Leave Balance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: leavesBalanceListData.isEmpty
                    ? [const Center(child: CircularProgressIndicator())]
                    : leavesBalanceListData.map((leave) {
                        final matchingLeaveName = leavesNameListData.firstWhere(
                          (leaveName) => leaveName['leaveId'] == leave['leaveId'],
                          orElse: () => <String, String?>{},
                        );
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child: Container(
                              decoration: const BoxDecoration(),
                              width: 170,
                              height: 120,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${leave['totalLeaves']}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Text(
                                      matchingLeaveName.isNotEmpty
                                          ? '${matchingLeaveName['leaveName'] ?? ''}'
                                          : '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: leaveHistoryListData.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: leaveHistoryListData.length,
                      itemBuilder: (context, index) {
                        final data = leaveHistoryListData[index];

                        String status;
                        Color backgroundColor;
                        Color textColor;

                        switch (data['leavePendingApprove']) {
                          case "0":
                            status = 'Pending';
                            backgroundColor = Colors.yellow;
                            textColor = Colors.brown;
                            break;
                          case "1":
                            status = 'Approved';
                            backgroundColor = Colors.green;
                            textColor = Colors.white;
                            break;
                          case "2":
                            status = 'Rejected';
                            backgroundColor = Colors.red;
                            textColor = Colors.white;
                            break;
                          case "3":
                            status = 'Canceled';
                            backgroundColor = Colors.grey;
                            textColor = Colors.white;
                            break;
                          default:
                            status = '';
                            backgroundColor = Colors.white;
                            textColor = Colors.white;
                        }

                        final dateRange = data['dateFrom'] == data['dateTo']
                            ? data['dateFrom']
                            : '${data['dateFrom']} / ${data['dateTo']}';

                        return SizedBox(
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['noOfDays'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          'Day',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          dateRange ?? "",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '${data['leaveType']}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Status Section
                                  GestureDetector(
                                    onTap: data['leavePendingApprove'] == "0"
                                        ? () {
                                            _showBottomSheet(context, data);
                                          }
                                        : null,
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ApplyLeave()));
                    },
                    child: Text(
                      '+ APPLY LEAVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Map<String, dynamic> data) {
    final dateRange = data['dateFrom'] == data['dateTo']
        ? 'Leave on ${data['dateFrom']} for ${data['noOfDays']} day${data['noOfDays'] == "1" ? "" : "s"}'
        : 'Leave from ${data['dateFrom']} to ${data['dateTo']} for ${data['noOfDays']} days';

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(1.0),
        child: SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['leaveType'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  dateRange,
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showValidationDialog(context, data['employeesLeaveId']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Cancel Leave',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showValidationDialog(BuildContext context, String employeesLeaveId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Leave'),
        content: const Text('Are you sure you want to cancel this leave?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final token =
                  await leaveCancelViewModel.sessionManager.getToken();
              await leaveCancelViewModel.markLeaveCancel(
                token!,
                employeesLeaveId: employeesLeaveId,
              );
              fetchLeaveHistoryData();
              fetchEmployeeLeavesData();
              debugPrint('Cancel Leave Action for ID: $employeesLeaveId');
            },
            child: const Text('Yes'),
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
