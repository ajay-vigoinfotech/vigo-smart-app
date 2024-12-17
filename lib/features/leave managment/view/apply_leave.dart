import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/home/view/home_page.dart';
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
    checkInternetConnection();
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
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        insetPadding: EdgeInsets.all(20),
                        child: StatefulBuilder(
                          builder: (dialogContext, setDialogState) => Container(
                            padding: const EdgeInsets.all(16),
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.6,
                              maxWidth: 500,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Designation',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
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
            SizedBox(height: 15),
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
                Text(
                  "Full Day",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
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
                Text(
                  "Multi Days",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
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
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context,
                            (date) => setState(() => startDate = date));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade300),
                        ),
                        child: Row(
                          children: [
                            Text(
                              startDate != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(startDate!) // Format date
                                  : "Select Date*",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],

            // Multi Days
            if (isMultiDays) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.calendar_month, color: Colors.blue),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context, (date) {
                          setState(() {
                            startDate = date;
                            endDate = null;
                          });
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: startDate == null
                              ? Colors.blue.shade50
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: startDate == null
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade300),
                        ),
                        child: Row(
                          children: [
                            Text(
                              startDate != null
                                  ? DateFormat('dd-MM-yyyy').format(startDate!)
                                  : "Start Date*",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: startDate == null
                                    ? Colors.blue
                                    : Colors.blue,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.calendar_month, color: Colors.blue),
                    GestureDetector(
                      onTap: startDate != null
                          ? () {
                              _selectDate(
                                context,
                                (date) => setState(() => endDate = date),
                                minDate: startDate,
                              );
                            }
                          : () {
                              Fluttertoast.showToast(
                                msg: "Please select a Start Date first",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: endDate == null
                              ? Colors.blue.shade50
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: startDate == null
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade300),
                        ),
                        child: Row(
                          children: [
                            Text(
                              endDate != null
                                  ? DateFormat('dd-MM-yyyy').format(endDate!)
                                  : "End Date*",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:
                                    endDate == null ? Colors.blue : Colors.blue,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 15),
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
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        remark = value;
                      },
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintText: 'Reason for leave',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                      maxLines: 4,
                      cursorColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 5,
                ),
                onPressed: () async {
                  await checkInternetConnection();
                  if (selectedLeaveId.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please Select Leave Type",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  if (startDate == null) {
                    Fluttertoast.showToast(
                      msg: "Please Select Date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  if (isMultiDays && endDate == null) {
                    Fluttertoast.showToast(
                      msg: "Please Select End Date",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  debugPrint('Apply Leave Button Tapped');

                  String? token = await sessionManager.getToken();
                  ApplyLeaveViewModel applyLeaveViewModel =
                      ApplyLeaveViewModel();
                  bool isSingleDayLeave =
                      endDate == null || startDate == endDate;

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

                  int? statusCode =
                      response['httpStatusCode']?[0]['statusCode'];
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
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'Unknown Error',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                child: Text(
                  'APPLY',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 30),
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
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              ),

              // Navigator.pop(context),
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
