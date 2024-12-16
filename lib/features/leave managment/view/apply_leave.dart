import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../../home/view/home_page.dart';
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
  String? selectedLeaveName;
  String? selectedLeaveId;
  bool isMultiDays = false;
  DateTime? startDate;
  DateTime? endDate;
  SessionManager sessionManager = SessionManager();

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
                                            '';
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
                                        // Set the selected leave name
                                        setState(() {
                                          selectedLeaveName =
                                              matchingLeaveName['leaveName'];
                                          selectedLeaveId = leave['leaveId'];
                                        });
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
            Text("Select Date:", style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                _selectDate(
                    context, (date) => setState(() => startDate = date));
              },
              child: Text(startDate != null
                  ? "${startDate!.toLocal()}".split(' ')[0]
                  : "Select Date"),
            ),
          ],

          // Date Pickers for Multi Days
          if (isMultiDays) ...[
            // Start Date
            Text("Start Date:", style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                _selectDate(context, (date) {
                  setState(() {
                    startDate = date;
                    endDate = null; // Reset end date when start date changes
                  });
                });
              },
              child: Text(startDate != null
                  ? "${startDate!.toLocal()}".split(' ')[0]
                  : "Select Start Date"),
            ),

            SizedBox(height: 8),
            // End Date
            Text("End Date:", style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: startDate != null
                  ? () {
                      _selectDate(
                          context, (date) => setState(() => endDate = date),
                          minDate:
                              startDate); // Start date as minimum selectable date
                    }
                  : null, // Disable until start date is selected
              child: Text(endDate != null
                  ? "${endDate!.toLocal()}".split(' ')[0]
                  : "Select End Date",
              ),
            ),
          ],
          SizedBox(height: 16),
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
                      remark: 'remark',
                      leaveTypeId: '$selectedLeaveId',
                      dateFrom: '$startDate'
                  ),
                );

                if (response['code'] == 200) {
                  // Navigator.of(context).pop();

                  QuickAlert.show(
                    confirmBtnText: 'Ok',
                    context: context,
                    type: QuickAlertType.success,
                    text: '${response['message']}',
                    onConfirmBtnTap: () {
                      Navigator.pushAndRemoveUntil(
                        this.context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${response['status']}')),
                  );
                }
              },
              child: Text('Apply leave'),
          ),
        ],
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
