import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../../core/utils.dart';
import '../../markduty/viewmodel/get_current_date_view_model.dart';
import '../model/field_reporting_model.dart';
import '../view model/field_reporting_view_model.dart';

class FieldReporting extends StatefulWidget {
  const FieldReporting({super.key});

  @override
  State<FieldReporting> createState() => _FieldReportingState();
}

class _FieldReportingState extends State<FieldReporting> {
  SessionManager sessionManager = SessionManager();
  String? savedImagePath;
  String? punchTimeDateIn;
  String timeDateDisplay = '';
  String uniqueIdv4 = '';
  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';

  @override
  void initState() {
    _loadCurrentDateTime();
    _loadPunchInImageFromSP();
    _getPunchTimeDateInFromSP();
    super.initState();
  }

  // Build the MapView with dynamic height
  Widget _buildMapView() {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width * 0.9,
      child: MapPage(
        locationReceived: _onLocationReceived,
        speedReceived: _onSpeedReceived,
        accuracyReceived: _onAccuracyReceived,
      ),
    );
  }

  // Location Callback
  void _onLocationReceived(String formattedLocation) {
    setState(() {
      formattedLatLng = formattedLocation;
    });
  }

  // Speed Callback
  void _onSpeedReceived(String formattedSpeed) {
    setState(() {
      formattedSpeedValue = formattedSpeed;
    });
  }

  // Accuracy Callback
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
      savedImagePath = imagePath;
    });
  }

  Future<void> _savePunchTimeDateInToSP(String punchTimeDateInValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('punchTimeDateIn', punchTimeDateInValue);
    setState(() {
      punchTimeDateIn = punchTimeDateInValue; // Update local state
    });
  }

  Future<void> _getPunchTimeDateInFromSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      punchTimeDateIn = prefs.getString('punchTimeDateIn');
    });
  }

  Future<void> onInButtonPressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? patrollingImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 1,
    );

    if (patrollingImage != null) {
      final File image = File(patrollingImage.path);
      final List<int>? compressedBytes =
          await FlutterImageCompress.compressWithFile(
        image.absolute.path,
        minWidth: 400,
        minHeight: 400,
        quality: 1,
      );

      if (compressedBytes != null) {
        final String base64Image = base64Encode(compressedBytes);

        // Show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Center(child: Text("Mark Patrolling")),
                  content: SizedBox(
                    width: 800,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.file(
                            image,
                            height: 125,
                            width: 125,
                          ),
                          const SizedBox(height: 3),
                          TextField(
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: "Enter comment",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _loadCurrentDateTime();
                        punchTimeDateIn = timeDateDisplay;
                        await _savePunchTimeDateInToSP(
                            punchTimeDateIn!); // Save to SP
                        await _saveImageToSP(patrollingImage.path);
                        uniqueIdv4 = const Uuid().v4();

                        String? token = await sessionManager.getToken();
                        MarkFieldReportingViewModel
                            markFieldReportingViewModel =
                            MarkFieldReportingViewModel();
                        final String deviceDetails =
                            await Utils.getDeviceDetails(context);
                        final String appVersion = await Utils.getAppVersion();
                        final String ipAddress = await Utils.getIpAddress();
                        final String uniqueId = await Utils.getUniqueID();
                        final int battery = await Utils.getBatteryLevel();

                        String formatDate(String dateString) {
                          DateFormat inputFormat =
                              DateFormat("dd/MM/yyyy hh:mm a");
                          DateTime dateTime = inputFormat.parse(dateString);
                          DateFormat outputFormat =
                              DateFormat("yyyy-MM-dd HH:mm");
                          return outputFormat.format(dateTime);
                        }

                        String formattedDateTimeIn =
                            formatDate(punchTimeDateIn!);

                        Map<String, dynamic> response =
                            await markFieldReportingViewModel
                                .markFieldReporting(
                          token!,
                          MarkFieldReportingModel(
                            deviceDetails: deviceDetails,
                            deviceImei: uniqueId,
                            deviceIp: ipAddress,
                            userPhoto: base64Image,
                            remark: '',
                            isOffline: 'false',
                            version: appVersion,
                            dataStatus: '',
                            checkInId: uniqueIdv4,
                            punchAction: 'IN',
                            locationAccuracy: formattedAccuracyValue,
                            locationSpeed: formattedSpeedValue,
                            batteryStatus: '$battery',
                            locationStatus: 'true',
                            time: formattedDateTimeIn,
                            latLong: formattedLatLng,
                            kmsDriven: '',
                            siteId: '',
                            locationId: '',
                            distance: '',
                          ),
                        );
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.fieldReportingApp),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('MARK PATROLLING')),
              Tab(child: Text('PUNCH HISTORY')),
            ],
          ),
        ),
        body: TabBarView(
          //physics: const NeverScrollableScrollPhysics(),
          children: [
            // MARK PATROLLING Tab Content
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(child: Text(timeDateDisplay,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  const SizedBox(height: 10),
                  _buildMapView(),
                  const SizedBox(height: 25),
                  Text(
                    punchTimeDateIn ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (savedImagePath != null && savedImagePath!.isNotEmpty)
                    Image.file(
                      File(savedImagePath!),
                      height: 130,
                      width: 120,
                    ),
                  const SizedBox(height: 10),
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
                      onPressed: onInButtonPressed,
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
            ),
            // PUNCH HISTORY Tab Content
            const Center(
              child: Text('2nd Tab'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCurrentDateTime() async {
    final getCurrentDateViewModel = GetCurrentDateViewModel();
    String? currentDateTime;

    try {
      currentDateTime = await Future.any([
        getCurrentDateViewModel.getTimeDate(),
        Future.delayed(const Duration(seconds: 5), () => null)
      ]);

      if (currentDateTime != null) {
        final formattedDateTime = Utils.formatDateTime(currentDateTime);
        setState(() {
          timeDateDisplay = formattedDateTime;
        });
      } else {
        currentDateTime = _setDeviceDateTime();
      }
    } catch (e) {
      currentDateTime = _setDeviceDateTime();
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
}
