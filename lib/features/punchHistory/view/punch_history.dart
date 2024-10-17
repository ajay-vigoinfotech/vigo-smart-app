import 'package:flutter/material.dart';

import '../../auth/session_manager/session_manager.dart';
import '../model/getselfieattendance_model.dart';
import '../viewmodel/getselfieattendance_view_model.dart';

class PunchHistory extends StatefulWidget {
  const PunchHistory({super.key});

  @override
  State<PunchHistory> createState() => _PunchHistoryState();
}

class _PunchHistoryState extends State<PunchHistory> {
  List<SelfieAttendanceTable> punchData = [];

  final String baseUrl = 'http://ios.smarterp.live';

  @override
  void initState() {
    super.initState();
    fetchPunchHistory();
  }

  Future<void> fetchPunchHistory() async {
    final SessionManager sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null || token.isEmpty) {
      print('Failed to retrieve token.');
      return;
    }

    final GetSelfieAttendanceViewModel getSelfieAttendanceViewModel = GetSelfieAttendanceViewModel();
    final GetSelfieAttendanceViewModel? viewModel = await getSelfieAttendanceViewModel.getSelfieAttendance(token);

    if (viewModel != null && viewModel.getSelfieAttendanceModel != null) {
      setState(() {
        punchData = viewModel.getSelfieAttendanceModel!.table ?? [];
      });
    } else {
      print('Failed to fetch attendance data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punch History'),
      ),
      body: punchData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: punchData.length,
        itemBuilder: (context, index) {
          final attendance = punchData[index];

          // Corrected URLs for images (removing ../ and appending base URL)
          final inPhotoUrl = attendance.inPhoto != null
              ? '$baseUrl${attendance.inPhoto!.replaceFirst('../', '/')}'
              : null;
          final outPhotoUrl = attendance.outPhoto != null
              ? '$baseUrl${attendance.outPhoto!.replaceFirst('../', '/')}'
              : null;

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Punch In Section
                  const Text(
                    'Punch In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date Time In: ${attendance.dateTimeIn ?? "N/A"}'),
                            Text('Location: ${attendance.location ?? "N/A"}'),
                            Text('In Remarks: ${attendance.inRemarks ?? "N/A"}'),
                            Text('In Kms Driven: ${attendance.inKmsDriven ?? "N/A"}'),
                          ],
                        ),
                      ),
                      if (inPhotoUrl != null) // Display image on the right side
                        Image.network(
                          inPhotoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.red),
                        ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.grey),

                  // Punch Out Section
                  const Text(
                    'Punch Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date Time Out: ${attendance.dateTimeOut ?? "N/A"}'),
                            Text('Out Location: ${attendance.outLocation ?? "N/A"}'),
                            Text('Out Remarks: ${attendance.outRemarks ?? "N/A"}'),
                            Text('Out Kms Driven: ${attendance.outKmsDriven ?? "N/A"}'),
                          ],
                        ),
                      ),
                      if (outPhotoUrl != null) // Display image on the right side
                        Image.network(
                          outPhotoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.red),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
