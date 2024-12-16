import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/home/view/home_page.dart';
import 'package:vigo_smart_app/features/leave%20managment/view/leave_management.dart';
import '../model/apply_leave_model.dart';
import '../view model/apply_leave_view_model.dart';
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
  String selectedLeaveName = '';
  String selectedLeaveId = '';
  bool isMultiDays = false;
  DateTime? startDate;
  DateTime? endDate;
  SessionManager sessionManager = SessionManager();
  String remark = '';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Select Leave Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Center(
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
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: StatefulBuilder(
                          builder: (dialogContext, setDialogState) => SizedBox(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      setDialogState(() {});
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
                                          matchingLeaveName['leaveName'] ?? '';
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
                                      final leaveName =
                                          matchingLeaveName['leaveName'] ?? '-';
                                      final totalLeaves =
                                          leave['totalLeaves'] ?? '0';
                                      return ListTile(
                                        title: Text(
                                          '$leaveName ($totalLeaves)',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedLeaveName =
                                                '$leaveName ($totalLeaves)';
                                            selectedLeaveId = leave['leaveId'];
                                          });
                                          Navigator.pop(context);
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
                                        child: Text('Cancel'),
                                      ),
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
                  child: Text(
                    selectedLeaveName.isEmpty
                        ? 'Select Leave Type'
                        : selectedLeaveName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Select Duration Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: false,
                  groupValue: isMultiDays,
                  onChanged: (value) {
                    setState(() {
                      isMultiDays = value as bool;
                      startDate = null;
                      endDate = null;
                    });
                  },
                ),
                Text("Full Day"),
                Radio(
                  value: true,
                  groupValue: isMultiDays,
                  onChanged: (value) {
                    setState(() {
                      isMultiDays = value as bool;
                      startDate = null;
                      endDate = null;
                    });
                  },
                ),
                Text("Multi Days"),
              ],
            ),
            SizedBox(height: 8),

            // Date Pickers for Full Day
            if (!isMultiDays) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.blue),
                    SizedBox(width: 8), // Add spacing between icon and button
                    GestureDetector(
                      onTap: () {
                        _selectDate(context,
                            (date) => setState(() => startDate = date));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50, // Light background
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.blue.shade300), // Add border
                        ),
                        child: Row(
                          children: [
                            Text(
                              startDate != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(startDate!) // Format date
                                  : "Select Date",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_drop_down, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],

            if (isMultiDays) ...[
              Row(
                children: [
                  Icon(Icons.calendar_month),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context, (date) {
                        setState(() {
                          startDate = date;
                          endDate = null;
                        });
                      });
                    },
                    child: Text(startDate != null
                        ? "${startDate!.toLocal()}".split(' ')[0]
                        : "Select Start Date"),
                  ),
                  Icon(Icons.calendar_month),
                  ElevatedButton(
                    onPressed: startDate != null
                        ? () {
                            _selectDate(context,
                                (date) => setState(() => endDate = date),
                                minDate: startDate);
                          }
                        : null,
                    child: Text(
                      endDate != null
                          ? "${endDate!.toLocal()}".split(' ')[0]
                          : "Select End Date",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
            SizedBox(height: 16),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Reason for leave',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      remark = value;
                    },
                    decoration: InputDecoration(hintText: 'Reason for leave'),
                    // maxLines: 3,
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                debugPrint('Apply Leave Button Tapped');

                String? token = await sessionManager.getToken();
                ApplyLeaveViewModel applyLeaveViewModel = ApplyLeaveViewModel();
                bool isSingleDayLeave = endDate == null || startDate == endDate;

                Map<String, dynamic> response =
                    await applyLeaveViewModel.markApplyLeave(
                  token!,
                  ApplyLeaveModel(
                    dateTo: isSingleDayLeave ? '$startDate' : '$endDate',
                    action: '1',
                    remark: remark,
                    leaveTypeId: selectedLeaveId,
                    dateFrom: '$startDate',
                  ),
                );

                int? statusCode = response['httpStatusCode']?[0]['statusCode'];
                String message = response['httpStatusCode']?[0]['message'];

                if (statusCode == 200) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: message,
                    onConfirmBtnTap: () {
                      Navigator.pushAndRemoveUntil(
                        this.context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    },
                  );
                } else if (statusCode == 418) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: message,
                    onConfirmBtnTap: () {
                      Navigator.pushAndRemoveUntil(
                        this.context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    },
                  );
                }
              },
              child: Text('Apply leave'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDatePicked,
      {DateTime? minDate}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minDate ?? DateTime.now(),
      firstDate: minDate ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) onDatePicked(picked);
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
