import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../viewmodel/get_current_date_view_model.dart';

class MarkdutyPage extends StatefulWidget {
  const MarkdutyPage({super.key});

  @override
  State<MarkdutyPage> createState() => _MarkdutyPageState();
}

class _MarkdutyPageState extends State<MarkdutyPage> {
  var uuid = const Uuid();
  String? timeDateDisplay;
  String? timeDateIn;
  String? timeDateOut;
  String? siteID;
  String? siteName;
  bool _hasCheckedIn = false; // Tracks if the user has punched in
  bool _hasCheckedOut = false; // Tracks if the user has punched out
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentDateTime(); // Get time and date from API
    _setDeviceDateTime(); // Get time and date from current device
    _loadCheckInOutStatus(); // Load check-in/out status
  }

  Future<void> _loadCheckInOutStatus() async {
    _hasCheckedIn = await sessionManager.getCheckInStatus();
    _hasCheckedOut = await sessionManager.getCheckOutStatus();
    setState(() {}); // Update the UI
  }

  Future<String?> _loadCurrentDateTime() async {
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
          timeDateIn = formattedDateTime;
          timeDateOut = formattedDateTime;
        });
      } else {
        currentDateTime = _setDeviceDateTime(); // Fallback to device time
      }
    } catch (e) {
      print('Error fetching date from API: $e');
      currentDateTime = _setDeviceDateTime(); // Fallback to device time
    }

    return currentDateTime;
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

  final SessionManager sessionManager = SessionManager();

  // Pick and display Punch-In image
  Future<void> _pickPunchInImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? punchInImage =
        await picker.pickImage(source: ImageSource.camera);

    if (punchInImage != null) {
      // Show the dialog and handle its outcome (whether to save or cancel)
      _showPunchInImageDialog(punchInImage);
    }
  }

  // Pick and display Punch-Out image
  Future<void> _pickPunchOutImage() async {
    if (_hasCheckedIn && !_hasCheckedOut) {
      final ImagePicker picker = ImagePicker();
      final XFile? punchOutImage =
          await picker.pickImage(source: ImageSource.camera);

      if (punchOutImage != null) {
        _showPunchOutImageDialog(punchOutImage);
      }
    } else {
      // Notify the user they must punch in before punching out
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You need to punch IN before punching OUT!"),
        ),
      );
    }
  }

  // Show a dialog to input KM and Comment, and handle submit or cancel
  void _showPunchInImageDialog(XFile punchInImage) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(punchInImage.path),
                    height: 150,
                    width: 125,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter KM'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(labelText: 'Enter Comment'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await sessionManager.saveCheckInStatus(true);
                  _hasCheckedIn = true;

                  String generatedUuid = uuid.v4();
                  print('Unique ID: $generatedUuid');

                  // Save the current date/time for Punch-In
                  String? currentTime = await _loadCurrentDateTime();
                  await sessionManager.saveTimeDateIn(
                      currentTime!); // Save Punch-In date and time

                  print('KM: ${_kmController.text}');
                  print('Comment: ${_commentController.text}');
                  print('Punch-In DateTime: $currentTime');

                  Navigator.pop(context, true); // Pop the dialog
                },
                child: const Text('Submit'),
              ),
            ],
          );
        }).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }

  // Show a dialog to input KM and Comment, and handle submit or cancel
  void _showPunchOutImageDialog(XFile punchOutImage) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(punchOutImage.path),
                    height: 150,
                    width: 125,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter KM'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(labelText: 'Enter Comment'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _hasCheckedOut = true;

                  // Save the current date/time for Punch-Out
                  String? currentTime = await _loadCurrentDateTime();
                  await sessionManager.saveTimeDateOut(
                      currentTime!); // Save Punch-Out date and time

                  print('KM: ${_kmController.text}');
                  print('Comment: ${_commentController.text}');
                  print('Punch-Out DateTime: $currentTime');

                  Navigator.pop(context, true); // Pop the dialog
                },
                child: const Text('Submit'),
              ),
            ],
          );
        }).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<String?>(
        future: sessionManager.getPunchInImagePath(),
        builder: (context, punchInSnapshot) {
          final punchInImagePath = punchInSnapshot.data;

          return FutureBuilder<String?>(
            future: sessionManager.getTimeDateIn(), // Fetch Punch-In time
            builder: (context, punchInTimeSnapshot) {
              final timeDateIn = punchInTimeSnapshot.data;

              return FutureBuilder<String?>(
                future: sessionManager.getTimeDateOut(), // Fetch Punch-Out time
                builder: (context, punchOutTimeSnapshot) {
                  final timeDateOut = punchOutTimeSnapshot.data;

                  // Fetch Punch-Out image path
                  final Future<String?> punchOutImagePathFuture =
                      sessionManager.getPunchOutImagePath();

                  return FutureBuilder<String?>(
                    future: punchOutImagePathFuture,
                    builder: (context, punchOutImageSnapshot) {
                      final punchOutImagePath = punchOutImageSnapshot.data;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                timeDateDisplay ?? 'Loading..',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: MapPage(latLong: ''),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(timeDateIn ?? ''),
                                  // Display Punch-In time
                                  if (punchInImagePath != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(punchInImagePath),
                                        height: 125,
                                        width: 110,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 80,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed:
                                          _hasCheckedIn && !_hasCheckedOut
                                              ? null
                                              : _pickPunchInImage,
                                      child: const Text(
                                        'IN',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(timeDateOut ?? ''),
                                  // Display Punch-Out image
                                  if (punchOutImagePath != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(punchOutImagePath),
                                        height: 125,
                                        width: 110,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 80,
                                    width: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: _pickPunchOutImage,
                                      child: const Text(
                                        'OUT',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
