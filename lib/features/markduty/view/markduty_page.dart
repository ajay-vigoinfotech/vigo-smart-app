import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? savedImagePath;
  String? savedPunchOutImagePath;
  String? punchTimeDateIn;
  String? punchTimeDateOut;
  String? timeDateDisplay;
  String? timeDateIn;
  String? timeDateOut;
  LatLng? currentLocation;

  String? uniqueId;
  String? inKm;
  String? outKm;
  // late FutureBuilder<AttendanceTable> _attData;
  final picker = ImagePicker();
  final SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    _loadPunchInImageFromSP();
    _loadPunchOutImageFromSP();
    sessionManager.getCheckinData().then((data) async {
      debugPrint(data.uniqueId);
      debugPrint(data.dateTimeIn);
      debugPrint(data.dateTimeOut);
      debugPrint(data.inKmsDriven);
      debugPrint(data.outKmsDriven);

      setState(() {
        punchTimeDateIn = data.dateTimeIn;
        timeDateIn = data.dateTimeIn;
        punchTimeDateOut = data.dateTimeOut;
        inKm = data.inKmsDriven;
        outKm = data.outKmsDriven;
      });
    });
    // _lastSelfieAttendance();
    _loadCurrentDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Duty'),
      ),
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
            height: 270,
            width: double.infinity,
            child: MapPage(locationReceived: _onLocationReceived),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '$punchTimeDateIn',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  // FutureBuilder(future:_attData, builder: builder),
                  Text(
                    '$inKm',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  if (savedImagePath != null && savedImagePath!.isNotEmpty)
                    Image.file(
                      File(savedImagePath!),
                      height: 130,
                      width: 120,
                    ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 70,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {

                        });
                        _onMarkIn(); // Mark In button action
                      },
                      child: const Text(
                        'IN',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$punchTimeDateOut',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$outKm',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  if (savedPunchOutImagePath != null &&
                      savedPunchOutImagePath!.isNotEmpty)
                    Image.file(
                      File(savedPunchOutImagePath!),
                      height: 130,
                      width: 120,
                    ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 70,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {

                        setState(() {
                        timeDateDisplay = "qwertyuiop";
                        });
                        // _onMarkOut(); // Mark Out button action
                      },
                      child: const Text(
                        'OUT',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
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
      timeDateOut = currentDateTime;
    });
    return currentDateTime;
  }

  void _onLocationReceived(LatLng latLng) {
    setState(() {
      currentLocation = latLng;
    });
  }

  // Load Punch In image from SharedPreferences
  Future<void> _loadPunchInImageFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedImagePath = prefs.getString('savedImagePath'); // Load image path
    });
  }

  // Save Punch In image path to SharedPreferences
  Future<void> _saveImageToSP(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedImagePath', imagePath); // Save image path
    setState(() {
      savedImagePath = imagePath; // Update UI with new image
    });
  }

  // Load Punch Out image from SharedPreferences
  Future<void> _loadPunchOutImageFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedPunchOutImagePath =
          prefs.getString('savedPunchOutImagePath'); // Load image path
    });
  }

  // Save Punch Out image path to SharedPreferences
  Future<void> _savePunchOutImageToSP(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedPunchOutImagePath', imagePath); // Save image path
    setState(() {
      savedPunchOutImagePath = imagePath; // Update UI with new image
    });
  }

  // Function called when 'Mark In' is clicked
  Future<void> _onMarkIn() async {
    final ImagePicker picker = ImagePicker();
    final XFile? markInImage =
    await picker.pickImage(source: ImageSource.camera);

    if (markInImage != null) {
      final image = File(markInImage.path);
      timeDateIn = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Mark In Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(image, height: 100, width: 100),
                TextField(
                  decoration: const InputDecoration(labelText: 'Comment'),
                  onChanged: (value) {
                    // Handle comment input
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'KM'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    inKm = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (timeDateIn != null && inKm != null && inKm!.isNotEmpty) {
                    // Save image path and punch in data
                    await _saveImageToSP(markInImage.path);

                    uniqueId = const Uuid().v4();

                    SelfieAttendanceModel selfieAttendanceModel =
                    SelfieAttendanceModel(
                      table: [
                        AttendanceTable(
                          uniqueId: uniqueId,
                          dateTimeIn: timeDateIn,
                          inKmsDriven: '$inKm KM',
                          dateTimeOut: "-",
                          outKmsDriven: "-",
                          siteId: "",
                          siteName: "-",
                        ),
                      ],
                    );

                    // Save attendance model using sessionManager
                    await sessionManager
                        .saveSelfieAttendance(selfieAttendanceModel);

                    Navigator.of(context).pop();
                    _loadPunchInImageFromSP(); // Load image into UI
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                            'Please fill in all fields.',
                            style: TextStyle(),
                          )),
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
  }

  // Function called when 'Mark Out' is clicked
  Future<void> _onMarkOut() async {
    final ImagePicker picker = ImagePicker();
    final XFile? markOutImage =
    await picker.pickImage(source: ImageSource.camera);

    if (markOutImage != null) {
      final image = File(markOutImage.path);
      timeDateOut = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Mark Out Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(image, height: 100, width: 100),
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
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (outKm != null && outKm!.isNotEmpty) {
                    // Save image path and punch out data
                    await _savePunchOutImageToSP(markOutImage.path);
                    SelfieAttendanceModel selfieAttendanceModel =
                    SelfieAttendanceModel(
                      table: [
                        AttendanceTable(
                          uniqueId: uniqueId,
                          dateTimeIn: timeDateIn,
                          inKmsDriven: '$inKm',
                          dateTimeOut: timeDateOut,
                          outKmsDriven: '$outKm KM',
                          siteId: "",
                          siteName: "-",
                        ),
                      ],
                    );
                    // Save attendance model using sessionManager
                    await sessionManager.saveSelfieAttendance(selfieAttendanceModel);

                    Navigator.of(context).pop();
                    _loadPunchOutImageFromSP(); // Load image into UI
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all fields.')),
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
  }

  // Future<void> _lastSelfieAttendance() async {
  //   final SessionManager sessionManager = SessionManager();
  //   sessionManager.getToken().then((token) async {
  //     final GetlastselfieattViewModel getlastselfieattViewModel =
  //     GetlastselfieattViewModel();
  //     getlastselfieattViewModel.getLastSelfieAttendance(token!).then((data1) {
  //       sessionManager.getCheckinData().then((data) async {
  //         debugPrint(data.dateTimeIn);
  //         debugPrint(data.dateTimeOut);
  //         debugPrint(data.inKmsDriven);
  //         debugPrint(data.outKmsDriven);
  //
  //         setState(() {
  //           timeDateIn = data.dateTimeIn;
  //           timeDateOut = data.dateTimeOut;
  //           inKm = data.inKmsDriven;
  //           outKm = data.outKmsDriven;
  //         });
  //       });
  //     });
  //   }).catchError((error) {
  //     debugPrint('Error: $error');
  //   });
  // }

  Future<void> _lastSelfieAttendance() async {
    sessionManager.getToken().then((token) async {
      final GetlastselfieattViewModel getlastselfieattViewModel =
      GetlastselfieattViewModel();
      getlastselfieattViewModel.getLastSelfieAttendance(token!).then((data1) {
        sessionManager.getCheckinData().then((data) async {
          debugPrint(data.uniqueId);
          debugPrint(data.dateTimeIn);
          debugPrint(data.dateTimeOut);
          debugPrint(data.inKmsDriven);
          debugPrint(data.outKmsDriven);

          setState(() {
            punchTimeDateIn = data.dateTimeIn;
            timeDateIn = data.dateTimeIn;
            punchTimeDateOut = data.dateTimeOut;
            inKm = data.inKmsDriven;
            outKm = data.outKmsDriven;
            // _attData = AttendanceTable()
          });
        });
      });
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }
}
