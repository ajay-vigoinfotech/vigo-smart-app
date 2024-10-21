import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/features/auth/model/getlastselfieattendancemodel.dart';
import 'package:vigo_smart_app/features/markduty/model/markselfieattendance_model.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../viewmodel/get_current_date_view_model.dart';
import '../viewmodel/mark_selfie_view_model.dart';
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
  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';
  String uniqueIdv4 = "";
  String? inKm;
  String? dutyInRemark;
  String? dutyOutRemark;
  String? outKm;
  String? errorMessage;
  final picker = ImagePicker();
  final SessionManager sessionManager = SessionManager();
  final MarkSelfieAttendance markSelfieAttendance = MarkSelfieAttendance();

  @override
  void initState() {
    super.initState();
    _loadPunchInImageFromSP();
    _loadPunchOutImageFromSP();

    sessionManager.getCheckinData().then((data) {
      if (mounted) {
        setState(() {
          uniqueIdv4 = data.uniqueId ?? "";
          punchTimeDateIn = data.dateTimeIn;
          inKm = data.inKmsDriven;
          punchTimeDateOut = data.dateTimeOut;
          outKm = data.outKmsDriven;
        });
      }
    });
    _loadCurrentDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Duty'),
      ),
      body: SingleChildScrollView(
        // Wrap the body in SingleChildScrollView
        child: Column(
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
              child: MapPage(
                locationReceived: _onLocationReceived,
                speedReceived: _onSpeedReceived,
                accuracyReceived: _onAccuracyReceived,
              ),
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
                          if ((punchTimeDateIn == null &&
                                  (punchTimeDateOut == null ||
                                      punchTimeDateOut == "-")) ||
                              (punchTimeDateIn != null &&
                                  punchTimeDateOut != null &&
                                  punchTimeDateOut != "-")) {
                            setState(() {
                              _onMarkIn();
                            });
                          } else if (punchTimeDateIn != null &&
                              (punchTimeDateOut == null ||
                                  punchTimeDateOut == "-")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Already marked IN!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
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
                          if (punchTimeDateIn != null &&
                              punchTimeDateIn != "-" &&
                              (punchTimeDateOut == null ||
                                  punchTimeDateOut == "-")) {
                            setState(() {
                              _onMarkOut();
                            });
                          } else if (punchTimeDateIn == null ||
                              punchTimeDateIn == "-") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please mark IN before marking OUT!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Already marked OUT!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
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


  Future<void> _loadPunchInDateTime() async {
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

  void _onLocationReceived(String formattedLocation) {
    setState(() {
      formattedLatLng = formattedLocation;
    });
  }

  void _onSpeedReceived(String formattedSpeed) {
    setState(() {
      formattedSpeedValue = formattedSpeed;
    });
  }

  void _onAccuracyReceived(String formattedAccuracy) {
    setState(() {
      formattedAccuracyValue = formattedAccuracy;
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

  // Clear Punch Out image from SharedPreferences
  Future<void> _clearPunchOutImageFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('savedPunchOutImagePath'); // Remove Punch Out image path
    setState(() {
      savedPunchOutImagePath = null; // Update UI to clear image
    });
  }

  Future<void> _onMarkIn() async {
    if (formattedLatLng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No location found. Please enable location services.')),
      );
      return; // Exit the function early
    }
    // await _clearPunchOutImageFromSP();

    final ImagePicker picker = ImagePicker();
    final XFile? markInImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 1,
    );

    if (markInImage != null) {
      final File image = File(markInImage.path);
      final List<int>? compressedBytes =
          await FlutterImageCompress.compressWithFile(
        image.absolute.path,
        minWidth: 400,
        minHeight: 400,
        quality: 1,
      );

      if (compressedBytes != null) {
        final String base64Image = base64Encode(compressedBytes);
        final base64InImage = base64Image;

        punchTimeDateIn = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

        showDialog(
          barrierDismissible: false,
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
                      dutyInRemark = value;
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
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (punchTimeDateIn != null &&
                        inKm != null &&
                        inKm!.isNotEmpty) {
                      await _saveImageToSP(markInImage.path);
                      uniqueIdv4 = const Uuid().v4();

                      SelfieAttendanceModel selfieAttendanceModel = SelfieAttendanceModel(
                        table: [
                          AttendanceTable(
                            uniqueId: uniqueIdv4,
                            dateTimeIn: punchTimeDateIn,
                            inKmsDriven: '$inKm KM',
                            dateTimeOut: "-",
                            outKmsDriven: "-",
                            siteId: "",
                            siteName: "-",
                          ),
                        ],
                      );

                      await sessionManager.saveSelfieAttendance(selfieAttendanceModel);

                      String? token = await sessionManager.getToken();
                      MarkSelfieAttendance markSelfieAttendance = MarkSelfieAttendance();
                      final String deviceDetails = await Utils.getDeviceDetails(context);
                      final String appVersion = await Utils.getAppVersion();
                      final String ipAddress = await Utils.getIpAddress();
                      final String uniqueId = await Utils.getUniqueID();
                      final int battery = await Utils.getBatteryLevel();

                      punchTimeDateIn = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

                      String apiResponse =
                          await markSelfieAttendance.markAttendance(
                              token!,
                              PunchDetails(
                                deviceDetails: deviceDetails,
                                deviceImei: uniqueId,
                                deviceIp: ipAddress,
                                userPhoto: base64InImage,
                                remark: dutyInRemark ?? '',
                                isOffline: '',
                                version: 'v$appVersion',
                                dataStatus: '',
                                checkInId: uniqueIdv4,
                                punchAction: 'IN',
                                locationAccuracy: formattedAccuracyValue,
                                locationSpeed: formattedSpeedValue,
                                batteryStatus: '$battery%',
                                locationStatus: 'true',
                                time: '$punchTimeDateIn',
                                latLong: formattedLatLng,
                                kmsDriven: '$inKm',
                                siteId: '',
                                locationId: '',
                                distance: '',
                              ));

                      await _clearPunchOutImageFromSP();

                      if (apiResponse == '200') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Attendance marked successfully!')),
                        );
                        _loadPunchInImageFromSP();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(apiResponse)),
                        );
                      }
                      Navigator.of(context).pop();
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
  }

// Function called when 'Mark Out' is clicked
  Future<void> _onMarkOut() async {
    if (formattedLatLng.isEmpty) {
      // Show a message indicating no location found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No location found. Please enable location services.')),
      );
      return; // Exit the function early
    }
    final ImagePicker picker = ImagePicker();
    final XFile? markOutImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 1);

    if (markOutImage != null) {
      final image = File(markOutImage.path);
      punchTimeDateOut =
          DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

      // Compress the image
      final compressedImageBytes = await FlutterImageCompress.compressWithFile(
        markOutImage.path,
        minWidth: 400,
        minHeight: 400,
        quality: 1,
      );

      // Convert compressed image to Base64
      if (compressedImageBytes != null) {
        final String base64Image = base64Encode(compressedImageBytes);
        final base64OutImage = base64Image;

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Mark Out Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(image, height: 100, width: 100),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Out Remark'),
                    onChanged: (value) {
                      dutyOutRemark = value;
                    },
                  ),
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
                            uniqueId: uniqueIdv4,
                            dateTimeIn: punchTimeDateIn,
                            inKmsDriven: '$inKm',
                            dateTimeOut: punchTimeDateOut,
                            outKmsDriven: '$outKm KM',
                            siteId: "",
                            siteName: "-",
                          ),
                        ],
                      );
                      // Save attendance model using sessionManager
                      await sessionManager
                          .saveSelfieAttendance(selfieAttendanceModel);

                      String? token = await sessionManager.getToken();
                      MarkSelfieAttendance markSelfieAttendance =
                          MarkSelfieAttendance();
                      final String deviceDetails =
                          await Utils.getDeviceDetails(context);
                      final String appVersion = await Utils.getAppVersion();
                      final String ipAddress = await Utils.getIpAddress();
                      final String uniqueId = await Utils.getUniqueID();
                      final int battery = await Utils.getBatteryLevel();

                      punchTimeDateOut =
                          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

                      final String fullDeviceDetails = deviceDetails;

                      String apiResponse =
                          await markSelfieAttendance.markAttendance(
                        token!,
                        PunchDetails(
                          deviceDetails: fullDeviceDetails,
                          deviceImei: uniqueId,
                          deviceIp: ipAddress,
                          userPhoto: base64OutImage,
                          remark: '$dutyOutRemark',
                          isOffline: 'false',
                          version: appVersion,
                          dataStatus: '',
                          checkInId: uniqueIdv4,
                          punchAction: 'OUT',
                          locationAccuracy: formattedAccuracyValue,
                          locationSpeed: formattedSpeedValue,
                          batteryStatus: '$battery',
                          locationStatus: '',
                          time: '$punchTimeDateOut',
                          latLong: formattedLatLng,
                          kmsDriven: '$outKm',
                          siteId: '',
                          locationId: '',
                          distance: '',
                        ),
                      );

                      if (apiResponse == '200') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Attendance marked successfully')),
                        );
                      } else {
                        // Show error if API failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('OUT$apiResponse')),
                        );
                      }
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
  }
}
