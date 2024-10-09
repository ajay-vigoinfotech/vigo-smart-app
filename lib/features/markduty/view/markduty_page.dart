import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../../core/utils.dart';
import '../../auth/model/getlastselfieattendancemodel.dart';
import '../../auth/session_manager/session_manager.dart';
import '../viewmodel/get_current_date_view_model.dart';

class MarkdutyPage extends StatefulWidget {
  const MarkdutyPage({super.key});

  @override
  State<MarkdutyPage> createState() => _MarkdutyPageState();
}

class _MarkdutyPageState extends State<MarkdutyPage> {
  String? timeDateDisplay;
  String? uniqueId;
  String? punchDutyIn;
  String? punchDutyOut;
  String? inKm;
  String? outKm;
  LatLng? currentLocation;

  final SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    _lastSelfieAttendance();
    _loadCurrentDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Duty'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('$timeDateDisplay'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 280,
                width: double.infinity,
                child: MapPage(locationReceived: _onLocationReceived),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('$punchDutyIn'),
                    Text('$inKm'),
                    ElevatedButton(
                      onPressed: () {
                        _onMarkIn();
                      },
                      child: const Text('IN'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('$punchDutyOut'),
                    Text('$outKm'),
                    ElevatedButton(
                      onPressed: () {
                        _onMarkOut();
                      },
                      child: const Text('OUT'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCurrentDateTime() async {
    final sessionManager = SessionManager();
    final getCurrentDateViewModel = GetCurrentDateViewModel();
    String? currentDateTime;

    try {
      currentDateTime = await getCurrentDateViewModel.getTimeDate();
      if (currentDateTime != null) {
        final formattedDateTime = Utils.formatDateTime(currentDateTime);
        await sessionManager.saveCurrentDateTime(formattedDateTime);

        setState(() {
          timeDateDisplay = formattedDateTime;
        });
      } else {
        currentDateTime = _setDeviceDateTime(); // Fallback to device time
      }
    } catch (e) {
      debugPrint('Error fetching date from API: $e');
      currentDateTime = _setDeviceDateTime(); // Fallback to device time
    }
  }

  String _setDeviceDateTime() {
    String currentDateTime =
        DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
    setState(() {
      timeDateDisplay = currentDateTime;
    });
    return currentDateTime;
  }

  void _onLocationReceived(LatLng latLng) {
    setState(() {
      currentLocation = latLng;
    });
  }

  Future<void> _onMarkIn() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage the state inside the dialog
          builder: (context, setState) {
            String? errorMessage; // To store validation error message

            return AlertDialog(
              title: const Center(child: Text('Mark In')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'In KM',
                      errorText:
                          errorMessage, // Display error message if not null
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        inKm = value;
                        // Clear the error message when user enters a valid value
                        if (inKm != null && inKm!.isNotEmpty) {}
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (inKm == null) {
                      setState(() {
                        errorMessage =
                            'Please enter start KM'; // Show error message
                      });
                    } else {
                      uniqueId = const Uuid().v4();
                      debugPrint(uniqueId);

                      SelfieAttendanceModel selfieAttendanceModel =
                          SelfieAttendanceModel(
                        table: [
                          AttendanceTable(
                            uniqueId: uniqueId,
                            dateTimeIn: punchDutyIn,
                            inKmsDriven: '$inKm KM',
                            dateTimeOut: "-",
                            outKmsDriven: "-",
                            siteId: "",
                            siteName: "-",
                          ),
                        ],
                      );

                      await sessionManager
                          .saveSelfieAttendance(selfieAttendanceModel);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onMarkOut() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage the state inside the dialog
          builder: (context, setState) {
            String? errorMessage; // To store validation error message

            return AlertDialog(
              title: const Center(child: Text('Mark Out')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Out KM',
                      errorText:
                          errorMessage, // Display error message if not null
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        outKm = value;
                        // Clear the error message when user enters a valid value
                        if (outKm != null && outKm!.isNotEmpty) {}
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (outKm == null) {
                      setState(() {
                        errorMessage =
                            'Please enter start KM'; // Show error message
                      });
                    } else {
                      SelfieAttendanceModel selfieAttendanceModel =
                          SelfieAttendanceModel(
                        table: [
                          AttendanceTable(
                            uniqueId: uniqueId,
                            dateTimeIn: punchDutyIn,
                            inKmsDriven: '$inKm KM',
                            dateTimeOut: punchDutyOut,
                            outKmsDriven: "$outKm KM",
                            siteId: "",
                            siteName: "-",
                          ),
                        ],
                      );

                      await sessionManager
                          .saveSelfieAttendance(selfieAttendanceModel);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _lastSelfieAttendance() async {
    final String? token = await sessionManager.getToken();

    if (token != null) {
      try {
        final data = await sessionManager.getCheckinData();

        debugPrint(data.uniqueId);
        debugPrint(data.dateTimeIn);
        debugPrint(data.dateTimeOut);
        debugPrint(data.inKmsDriven);
        debugPrint(data.outKmsDriven);

        setState(() {
          uniqueId = data.uniqueId;
          punchDutyIn = data.dateTimeIn;
          punchDutyOut = data.dateTimeOut;
          inKm = data.inKmsDriven;
          outKm = data.outKmsDriven;
        });
      } catch (error) {
        debugPrint('Error fetching attendance data: $error');
      }
    } else {
      debugPrint("Token is null");
    }
  }
}
