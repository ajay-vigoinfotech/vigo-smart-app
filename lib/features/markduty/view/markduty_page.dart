import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/features/auth/model/getlastselfieattendancemodel.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/viewmodel/getlastselfieatt_view_model.dart';
import '../viewmodel/get_current_date_view_model.dart';
import '../widgets/map_page.dart';

class MarkdutyPage extends StatefulWidget {
  const MarkdutyPage({super.key});

  @override
  State<MarkdutyPage> createState() => _MarkdutyPageState();
}

class _MarkdutyPageState extends State<MarkdutyPage> {
  String? punchTimeDateIn;
  String? punchTimeDateOut;
  String? timeDateDisplay;
  String? timeDateIn;
  String? timeDateOut;
  LatLng? currentLocation;
  String? uniqueId;
  String? inKm; // Declared uniqueId here so it persists across IN and OUT
  String? outKm; // Declared uniqueId here so it persists across IN and OUT
  final picker = ImagePicker();
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
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                '$timeDateDisplay',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 275,
            width: double.infinity,
            child: MapPage(locationReceived: _onLocationReceived),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('$punchTimeDateIn'),
                  Text('$inKm'),
                  ElevatedButton(
                    onPressed: () {
                      _onMarkIn(); // Mark In button action
                    },
                    child: const Text('IN'),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('$punchTimeDateOut'),
                  Text('$outKm'),
                  ElevatedButton(
                    onPressed: () {
                      _onMarkOut(); // Mark Out button action
                    },
                    child: const Text('OUT'),
                  ),
                ],
              ),
            ],
          )
        ],
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
          // timeDateIn = formattedDateTime;
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
      timeDateIn = currentDateTime;
    });
    return currentDateTime;
  }

  void _onLocationReceived(LatLng latLng) {
    setState(() {
      currentLocation = latLng;
    });
  }

  // Function called when 'Mark In' is clicked
  Future<void> _onMarkIn() async {
    String? comment;

    // Generate uniqueId when Mark In is clicked
    //uniqueId = Uuid().v4(); // Generates a new unique ID for "Mark In"
    timeDateIn = DateFormat('dd/MM/yyyy hh:mm')
        .format(DateTime.now()); // Capture IN time

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mark In Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Comment'),
                onChanged: (value) {
                  comment = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'KM'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  inKm = value; // Store inKm value when Mark In is clicked
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (inKm != null) {
                  uniqueId =
                      Uuid().v4(); // Generates a unique ID only for Mark In
                  SelfieAttendanceModel selfieAttendanceModel =
                      SelfieAttendanceModel(
                    table: [
                      AttendanceTable(
                        uniqueId: uniqueId,
                        dateTimeIn: timeDateDisplay, // Capture the IN time
                        inKmsDriven: '$inKm KM', // Capture the KM input
                        dateTimeOut: "-", // Set to null for Mark Out
                        outKmsDriven: "-", // Set to null for Mark Out
                        siteId: "", // Set your site ID logic
                        siteName: "-", // Set your site name logic
                      ),
                    ],
                  );

                  // Save the model in SharedPreferences using the session manager
                  await sessionManager
                      .saveSelfieAttendance(selfieAttendanceModel);

                  // Close the dialog
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // Function called when 'Mark Out' is clicked
  Future<void> _onMarkOut() async {
    String? outKm;
    timeDateOut = DateFormat('dd/MM/yyyy hh:mm a')
        .format(DateTime.now()); // Capture OUT time

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mark Out Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'OUT KM'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  outKm = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (outKm != null && outKm!.isNotEmpty) {
                  // Use the same uniqueId from IN for OUT
                  SelfieAttendanceModel selfieAttendanceModel =
                      SelfieAttendanceModel(
                    table: [
                      AttendanceTable(
                        uniqueId: uniqueId, // Use the same unique ID
                        dateTimeIn: timeDateIn, // Keep the IN time
                        inKmsDriven: '$inKm KM', // Previous km (if needed)
                        dateTimeOut: timeDateDisplay, // Capture OUT time
                        outKmsDriven: '$outKm KM', // Capture OUT KM
                        siteId: null, // Set your site ID logic
                        siteName: null, // Set your site name logic
                      ),
                    ],
                  );

                  // Save the model in SharedPreferences using the session manager
                  await sessionManager
                      .saveSelfieAttendance(selfieAttendanceModel);

                  // Close the dialog
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _lastSelfieAttendance() async {
    final SessionManager sessionManager = SessionManager();

    sessionManager.getToken().then((token) async {
      final GetlastselfieattViewModel getlastselfieattViewModel =
          GetlastselfieattViewModel();
      getlastselfieattViewModel
          .getLastSelfieAttendance(token!)
          .then((data1) async {
        sessionManager.getCheckinData().then((data) async {
          debugPrint(data.uniqueId);
          setState(() {
            uniqueId = data.uniqueId;
            punchTimeDateIn = data.dateTimeIn;
            timeDateIn = data.dateTimeIn;
            punchTimeDateOut = data.dateTimeOut;
            inKm = data.inKmsDriven;
            outKm = data.outKmsDriven;
          });
        });
      });
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }
}
