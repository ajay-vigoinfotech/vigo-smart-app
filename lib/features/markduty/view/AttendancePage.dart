import 'package:flutter/material.dart';

import '../../auth/session_manager/session_manager.dart';
import '../../auth/viewmodel/getlastselfieatt_view_model.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime? dateTimeIn;
  DateTime? dateTimeOut;

  @override
  void initState() {
    super.initState();
    _lastSelfieAttendance();
  }

  Future<void> _lastSelfieAttendance() async {
    final SessionManager sessionManager = SessionManager();
    try {
      final token = await sessionManager.getToken();
      final getlastselfieattViewModel = GetlastselfieattViewModel();

      final data1 = await getlastselfieattViewModel.getLastSelfieAttendance(token!);
      final checkinData = await sessionManager.getCheckinData();

      setState(() {
        dateTimeIn = checkinData.dateTimeIn as DateTime?;
        dateTimeOut = checkinData.dateTimeOut as DateTime?;
      });

      debugPrint(checkinData.uniqueId);
      debugPrint(checkinData.dateTimeIn);
      debugPrint(checkinData.dateTimeOut);
      debugPrint(checkinData.inKmsDriven);
      debugPrint(checkinData.outKmsDriven);
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (dateTimeIn == null && dateTimeOut == null) ? _checkIn : null,
              child: Text('IN'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (dateTimeIn != null && dateTimeOut == null) ? _checkOut : null,
              child: Text('OUT'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkIn() {
    // Logic for checking in (update dateTimeIn)
    debugPrint('Checking IN...');
    // Update the state or perform API call as needed
  }

  void _checkOut() {
    // Logic for checking out (update dateTimeOut)
    debugPrint('Checking OUT...');
    // Update the state or perform API call as needed
  }
}
