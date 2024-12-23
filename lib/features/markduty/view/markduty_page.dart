import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/features/auth/model/getlastselfieattendancemodel.dart';
import 'package:vigo_smart_app/features/markduty/model/markselfieattendance_model.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../../auth/viewmodel/getlastselfieatt_view_model.dart';
import '../../home/view/home_page.dart';
import '../viewmodel/get_current_date_view_model.dart';
import '../viewmodel/mark_selfie_view_model.dart';
import '../widgets/map_page.dart';

import 'dart:typed_data';
import 'package:image/image.dart' as img;


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
  String? inKmText;
  String? outKmText;
  String? dutyInRemark;
  String? dutyOutRemark;
  String? outKm;
  String? errorMessage;
  String _outKmError = '';
  String _inKmError = '';

  bool isLoading = false;

  String? formattedDateTime;
  String? deviceDetails;
  String? appVersion;
  String? ipAddress;
  String? uniqueId;
  String? battery;
  String? fcmToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final String currentDateTime = Utils.getCurrentFormattedDateTime();
    final String deviceInfo = await Utils.getDeviceDetails(context);
    final String version = await Utils.getAppVersion();
    final String ip = await Utils.getIpAddress();
    final String uniqueID = await Utils.getUniqueID();
    final int batteryStatus = await Utils.getBatteryLevel();
    String? fcmToken = await Utils.getFCMToken();

    setState(() {
      formattedDateTime = currentDateTime;
      deviceDetails = deviceInfo;
      appVersion = version;
      ipAddress = ip;
      uniqueId = uniqueID;
      battery = '$batteryStatus%';
      fcmToken = '$fcmToken';
    });
  }

  final TextEditingController _inKmController = TextEditingController();
  final TextEditingController _outKmController = TextEditingController();

  final picker = ImagePicker();
  final SessionManager sessionManager = SessionManager();
  final MarkSelfieAttendance markSelfieAttendance = MarkSelfieAttendance();
  final GetLastSelfieAttViewModel getLastSelfieAttViewModel = GetLastSelfieAttViewModel();

  @override
  void initState() {
    super.initState();
    _loadPunchInImageFromSP();
    _loadPunchOutImageFromSP();
    _loadCurrentDateTime();
    _fetchSelfieAttendanceData();
  }

  Future<void> _fetchSelfieAttendanceData() async {
    try {
      sessionManager.getCheckinData().then((data) {
        setState(() {
          uniqueIdv4 = data.uniqueId;
          punchTimeDateIn = data.dateTimeIn;
          punchTimeDateOut = data.dateTimeOut;
          inKm = data.inKmsDriven;
          outKm = data.outKmsDriven;
          inKmText = _parseToKmString(data.inKmsDriven);
          outKmText = _parseToKmString(data.outKmsDriven);
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  String _parseToKmString(String? kmsDriven) {
    try {
      return "${double.parse(kmsDriven ?? '').toInt()} KM";
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Duty'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTimeDateDisplay(),
            _buildMapView(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        punchTimeDateIn ?? '',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        inKmText ?? '',
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
                          onPressed: _onInButtonPressed,
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
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        punchTimeDateOut ?? '',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        outKmText ?? '',
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
                          onPressed: _onOutButtonPressed,
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _checkInternetConnection() async {
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
              onPressed: () => Navigator.pushAndRemoveUntil(
                this.context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              ),
              // Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  void _onInButtonPressed() async {
    bool isConnected = await _checkInternetConnection();
    if (!isConnected) return;

    if ((punchTimeDateIn == null || punchTimeDateIn == "") &&
        (punchTimeDateOut == null || punchTimeDateOut == "")) {
      setState(() {
        _onMarkIn();
      });
    } else if ((punchTimeDateIn != null && punchTimeDateIn != "") &&
        (punchTimeDateOut != null && punchTimeDateOut != "")) {
      // Allow marking IN if both have data
      setState(() {
        _onMarkIn();
      });
    } else if ((punchTimeDateIn != null && punchTimeDateIn != "") &&
        (punchTimeDateOut == null || punchTimeDateOut == "")) {
      // Only dateTimeIn is present, show warning
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Already marked IN!',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid punch-in attempt!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onOutButtonPressed() async {
    bool isConnected = await _checkInternetConnection();
    if (!isConnected) return;

    if ((punchTimeDateIn != null && punchTimeDateIn != "") &&
        (punchTimeDateOut == null || punchTimeDateOut == "")) {
      setState(() {
        _onMarkOut();
      });
    } else if (punchTimeDateIn == null || punchTimeDateIn == "") {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Please mark IN before marking OUT!',
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Already marked OUT!',
      );
    }
  }

  Widget _buildTimeDateDisplay() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: timeDateDisplay == null || timeDateDisplay!.isEmpty
            ? const CircularProgressIndicator()
            : Text(
                '$timeDateDisplay',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildMapView() {
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: MapPage(
        locationReceived: _onLocationReceived,
        speedReceived: _onSpeedReceived,
        accuracyReceived: _onAccuracyReceived,
        isMapVisible: true,
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
      savedPunchOutImagePath = prefs.getString('savedPunchOutImagePath');
    });
  }

  // Save Punch Out image path to SharedPreferences
  Future<void> _savePunchOutImageToSP(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedPunchOutImagePath', imagePath);
    setState(() {
      savedPunchOutImagePath = imagePath;
    });
  }

  // Clear Punch Out image from SharedPreferences
  Future<void> _clearPunchOutImageFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('savedPunchOutImagePath');
    setState(() {
      savedPunchOutImagePath = null;
    });
  }

  Future<void> _clearPunchOutData() async {
    // Clear the punch-out date-time and other fields
    punchTimeDateOut = '';
    outKm = '';
    await _clearPunchOutImageFromSP();
  }

  Future<void> _onMarkIn() async {
    if (formattedLatLng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No location found. Please enable location services.'),
        ),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? markInImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 1,
    );

    // if (markInImage != null) {
    //   final File image = File(markInImage.path);
    //
    //
    //   final List<int>? compressedBytes = await FlutterImageCompress.compressWithFile(
    //     image.absolute.path,
    //     minWidth: 400,
    //     minHeight: 400,
    //     quality: 10,
    //   );
    //
    //   if (compressedBytes != null) {
    //     final String base64Image = base64Encode(compressedBytes);
    //     final base64InImage = base64Image;

    if (markInImage != null) {
      final File image = File(markInImage.path);

      // Compress the image using the `image` package
      final img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
      if (originalImage != null) {
        final img.Image resizedImage = img.copyResize(
          originalImage,
          width: 400,
          height: 400,
        );

        final Uint8List compressedBytes = Uint8List.fromList(
          img.encodeJpg(resizedImage, quality: 20),
        );

        final String base64Image = base64Encode(compressedBytes);
        final base64InImage = base64Image;

        var temp = inKm;
        inKm = null;

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                final screenWidth = MediaQuery.of(context).size.width;
                return AlertDialog(
                  title: Center(child: const Text("Mark In Details", style: TextStyle(fontWeight: FontWeight.w600),)),
                  content: SizedBox(
                    width: screenWidth < 600 ? screenWidth * 0.9 : 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.file(image, height: 100, width: 100),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Comment'),
                            onChanged: (value) {
                              dutyInRemark = value;
                            },
                          ),
                          TextField(
                            controller: _inKmController,
                            decoration: InputDecoration(
                              labelText: 'KM',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              errorText: _inKmError,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              inKm = value;
                              setState(() {
                                inKmText = "$value KM";
                                outKmText = "";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () async {
                                  if (inKm == null || inKm!.isEmpty) {
                                    setState(() {
                                      _inKmError = 'Please enter in km!';
                                    });
                                    return;
                                  }

                                  if (inKm != null && inKm!.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await _loadCurrentDateTime();
                                    if (timeDateDisplay != null) {
                                      punchTimeDateIn = timeDateDisplay;
                                    }
                                    await _saveImageToSP(markInImage.path);
                                    uniqueIdv4 = const Uuid().v4();

                                    SelfieAttendanceModel
                                        selfieAttendanceModel =
                                        SelfieAttendanceModel(
                                      table: [
                                        AttendanceTable(
                                          uniqueId: uniqueIdv4,
                                          dateTimeIn: punchTimeDateIn ?? '',
                                          inKmsDriven: '$inKm',
                                          dateTimeOut: "",
                                          outKmsDriven: "",
                                          siteId: "",
                                          siteName: "-",
                                        ),
                                      ],
                                    );

                                    await sessionManager.saveSelfieAttendance(
                                        selfieAttendanceModel);

                                    print(
                                        "Selfie attendance data saved to session manager.");

                                    String? token =
                                        await sessionManager.getToken();
                                    MarkSelfieAttendance markSelfieAttendance =
                                        MarkSelfieAttendance();
                                    // final String deviceDetails = await Utils.getDeviceDetails(context);
                                    // final String appVersion = await Utils.getAppVersion();
                                    // final String ipAddress = await Utils.getIpAddress();
                                    // final String uniqueId = await Utils.getUniqueID();
                                    // final int battery = await Utils.getBatteryLevel();

                                    String formatDate(String dateString) {
                                      DateFormat inputFormat =
                                          DateFormat("dd/MM/yyyy hh:mm a");
                                      DateTime dateTime =
                                          inputFormat.parse(dateString);
                                      DateFormat outputFormat =
                                          DateFormat("yyyy-MM-dd HH:mm");
                                      return outputFormat.format(dateTime);
                                    }

                                    String formattedDateTimeIn =
                                        formatDate(punchTimeDateIn!);

                                    Map<String, dynamic> response =
                                        await markSelfieAttendance
                                            .markAttendance(
                                      token!,
                                      PunchDetails(
                                        deviceDetails: '$deviceDetails',
                                        deviceImei: '$uniqueId',
                                        deviceIp: '$ipAddress',
                                        userPhoto: base64InImage,
                                        remark: dutyInRemark ?? '',
                                        isOffline: '',
                                        version: 'v$appVersion',
                                        dataStatus: '',
                                        checkInId: uniqueIdv4,
                                        punchAction: 'IN',
                                        locationAccuracy:
                                            formattedAccuracyValue,
                                        locationSpeed: formattedSpeedValue,
                                        batteryStatus: '$battery%',
                                        locationStatus: 'true',
                                        time: formattedDateTimeIn,
                                        latLong: formattedLatLng,
                                        kmsDriven: '$inKm',
                                        siteId: '',
                                        locationId: '',
                                        distance: '',
                                      ),
                                    );

                                    await _clearPunchOutData();

                                    if (response['code'] == 200) {
                                      Navigator.of(context).pop();
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        text: '${response['status']}',
                                        onConfirmBtnTap: () {
                                          Navigator.pushAndRemoveUntil(
                                            this.context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                            (route) => false,
                                          );
                                        },
                                      );
                                      _loadPunchInImageFromSP();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error: ${response['status']}')),
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please fill in all fields.')),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ],
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

  Future<void> _onMarkOut() async {
    if (formattedLatLng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No location found. Please enable location services.'),
        ),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? markOutImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 1,
    );

    // if (markOutImage != null) {
    //   final File image = File(markOutImage.path);
    //   final compressedImageBytes = await FlutterImageCompress.compressWithFile(
    //     markOutImage.path,
    //     minWidth: 400,
    //     minHeight: 400,
    //     quality: 10,
    //   );
    //
    //   if (compressedImageBytes != null) {
    //     final String base64Image = base64Encode(compressedImageBytes);
    //     final base64OutImage = base64Image;

    if (markOutImage != null) {
      final File image = File(markOutImage.path);

      // Compress the image using the `image` package
      final img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
      if (originalImage != null) {
        final img.Image resizedImage = img.copyResize(
          originalImage,
          width: 400,
          height: 400,
        );

        final Uint8List compressedBytes = Uint8List.fromList(
          img.encodeJpg(resizedImage, quality: 20),
        );

        final String base64Image = base64Encode(compressedBytes);
        final base64OutImage = base64Image;

        bool isLoading = false;

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                final screenWidth = MediaQuery.of(context).size.width;
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Center(
                      child: const Text(
                    "Mark Out Details",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                  content: SizedBox(
                    width: screenWidth < 600 ? screenWidth * 0.9 : 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.file(image, height: 100, width: 100),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Out Remark'),
                            onChanged: (value) {
                              dutyOutRemark = value;
                            },
                          ),
                          TextField(
                            controller: _outKmController,
                            decoration: InputDecoration(
                              labelText: 'Out KM',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                              errorText: _outKmError,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              outKm = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        isLoading
                            ? const CircularProgressIndicator() // Show progress indicator
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () async {
                                  if (outKm == null || outKm!.isEmpty) {
                                    setState(() {
                                      _outKmError = 'Please enter out km!';
                                    });
                                    return;
                                  }
                                  if (isLoading) return;

                                  // Verify that Out KM is greater than In KM
                                  final double inKmValue =
                                      double.parse(inKm ?? '0.0');
                                  final double outKmValue =
                                      double.parse(outKm ?? '0.0');

                                  if (outKmValue < inKmValue) {
                                    setState(() {
                                      _outKmError =
                                          'Out KM must be greater than In KM';
                                    });
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                    outKmText = "$outKm KM";
                                  });

                                  if (outKm != null && outKm!.isNotEmpty) {
                                    await _loadCurrentDateTime();
                                    if (timeDateDisplay != null) {
                                      punchTimeDateOut = timeDateDisplay;
                                    }

                                    await _savePunchOutImageToSP(
                                        markOutImage.path);
                                    SelfieAttendanceModel
                                        selfieAttendanceModel =
                                        SelfieAttendanceModel(
                                      table: [
                                        AttendanceTable(
                                          uniqueId: uniqueIdv4,
                                          dateTimeIn: punchTimeDateIn ?? '',
                                          inKmsDriven: '$inKm',
                                          dateTimeOut: punchTimeDateOut ?? '',
                                          outKmsDriven: '$outKm',
                                          siteId: "",
                                          siteName: "-",
                                        ),
                                      ],
                                    );

                                    await sessionManager.saveSelfieAttendance(
                                        selfieAttendanceModel);

                                    String? token =
                                        await sessionManager.getToken();
                                    MarkSelfieAttendance markSelfieAttendance =
                                        MarkSelfieAttendance();
                                    final String deviceDetails =
                                        await Utils.getDeviceDetails(context);
                                    final String appVersion =
                                        await Utils.getAppVersion();
                                    final String ipAddress =
                                        await Utils.getIpAddress();
                                    final String uniqueId =
                                        await Utils.getUniqueID();
                                    final int battery =
                                        await Utils.getBatteryLevel();

                                    String formatDate(String dateString) {
                                      DateFormat inputFormat =
                                          DateFormat("dd/MM/yyyy hh:mm a");
                                      DateTime dateTime =
                                          inputFormat.parse(dateString);
                                      DateFormat outputFormat =
                                          DateFormat("yyyy-MM-dd HH:mm");
                                      return outputFormat.format(dateTime);
                                    }

                                    String formattedDateTimeOut =
                                        formatDate(punchTimeDateOut!);

                                    Map<String, dynamic> response =
                                        await markSelfieAttendance
                                            .markAttendance(
                                      token!,
                                      PunchDetails(
                                        deviceDetails: deviceDetails,
                                        deviceImei: uniqueId,
                                        deviceIp: ipAddress,
                                        userPhoto: base64OutImage,
                                        remark: dutyOutRemark ?? '',
                                        isOffline: 'false',
                                        version: appVersion,
                                        dataStatus: '',
                                        checkInId: uniqueIdv4,
                                        punchAction: 'OUT',
                                        locationAccuracy:
                                            formattedAccuracyValue,
                                        locationSpeed: formattedSpeedValue,
                                        batteryStatus: '$battery%',
                                        locationStatus: '',
                                        time: formattedDateTimeOut,
                                        latLong: formattedLatLng,
                                        kmsDriven: '$outKm',
                                        siteId: '',
                                        locationId: '',
                                        distance: '',
                                      ),
                                    );

                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (response['code'] == 200) {
                                      Navigator.of(context).pop();
                                      QuickAlert.show(
                                        context: context,
                                        barrierDismissible: false,
                                        type: QuickAlertType.success,
                                        confirmBtnTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20
                                        ),
                                        text: '${response['status']}',
                                        onConfirmBtnTap: () {
                                          Navigator.pushAndRemoveUntil(
                                            this.context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                            (route) => false,
                                          );
                                        },
                                      );
                                      _loadPunchInImageFromSP();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error: ${response['status']}')),
                                      );
                                    }
                                    _loadPunchOutImageFromSP();
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ],
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

  Future<void> lastSelfieAtt(
      SelfieAttendanceModel selfieAttendanceModel) async {
    final SessionManager sessionManager = SessionManager();
    try {
      await sessionManager.saveSelfieAttendance(selfieAttendanceModel);
      debugPrint('Selfie Attendance saved successfully!!!!!!!!!');
    } catch (error) {
      debugPrint('Error saving selfie attendance: $error');
    }
  }
}
