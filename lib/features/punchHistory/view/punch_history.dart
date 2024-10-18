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
  bool isLoading = true;
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

    final GetSelfieAttendanceViewModel getSelfieAttendanceViewModel =
        GetSelfieAttendanceViewModel();
    final GetSelfieAttendanceViewModel? viewModel =
        await getSelfieAttendanceViewModel.getSelfieAttendance(token);

    if (viewModel != null && viewModel.getSelfieAttendanceModel != null) {
      setState(() {
        punchData = viewModel.getSelfieAttendanceModel!.table ?? [];
        isLoading = false; // Stop loading after data is fetched
      });
    } else {
      print('Failed to fetch attendance data.');
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punch History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : punchData.isEmpty
              ? const Center(child: Text('No punch data available.'))
              : ListView.builder(
                  itemCount: punchData.length,
                  itemBuilder: (context, index) {
                    final attendance = punchData[index];

                    // Corrected URLs for images
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
                        child: Row(
                          children: [
                            // Punch In Card
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Punch In',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (inPhotoUrl != null)
                                      Image.network(
                                        inPhotoUrl,
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    color: Colors.red),
                                      )
                                    else
                                      const Icon(Icons.image_not_supported,
                                          size: 60, color: Colors.grey),
                                    const SizedBox(height: 10),
                                    Text(
                                      attendance.dateTimeIn ?? "No Data",
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      attendance.location?.split(',').first ??
                                          "No Location",
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Space between cards

                            // Punch Out Card with fixed size
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Punch Out',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // This ensures that the icon or image takes space
                                    if (outPhotoUrl != null)
                                      Image.network(
                                        outPhotoUrl,
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    color: Colors.red),
                                      )
                                    else
                                      const Icon(Icons.image_not_supported,
                                          size: 60, color: Colors.grey),
                                    const SizedBox(height: 10),
                                    Text(
                                      attendance.dateTimeOut ?? "No Data",
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      attendance.outLocation
                                              ?.split(',')
                                              .first ??
                                          "No Location",
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
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
