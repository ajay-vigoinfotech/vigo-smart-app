import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
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
    checkInternetConnection();
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
          : RefreshIndicator(
        onRefresh: fetchPunchHistory,
        child: ListView.builder(
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
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
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
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
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
                                    Image.asset(
                                      'assets/images/place_holder.webp',
                                      width: 130,
                                    ),
                              )
                            else
                              const Icon(Icons.image_not_supported,
                                  size: 60, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text(
                              (attendance.dateTimeOut ?? '').isNotEmpty
                                  ? attendance.dateTimeOut!
                                  : "Not marked yet",
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
      ),
    );
  }

  Future<void> fetchPunchHistory() async {
    final SessionManager sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null || token.isEmpty) {
      debugPrint('Failed to retrieve token.');
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
      debugPrint('Failed to fetch attendance data.');
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Show dialog to ask user to turn on internet connection
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content:
          const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
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

// // Function to refresh data
// Future<void> refreshData() async {
//   setState(() {
//     isLoading = true;
//   });
//   await fetchData(); // Call your data fetching method here
//   setState(() {
//     isLoading = false;
//   });
// }