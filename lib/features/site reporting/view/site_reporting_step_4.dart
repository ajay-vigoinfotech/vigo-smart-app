import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

import '../../../core/utils.dart';
import '../../home/view/home_page.dart';
import '../model/mark_site_visit_model.dart';
import '../view model/mark_site_visit_view_model.dart';

class SiteReportingStep4 extends StatefulWidget {
  final dynamic value;

  const SiteReportingStep4({super.key, required this.value});

  @override
  State<SiteReportingStep4> createState() => _SiteReportingStep4State();
}

class _SiteReportingStep4State extends State<SiteReportingStep4> {
  SessionManager sessionManager = SessionManager();
  MarkSiteVisitViewModel markSiteVisitViewModel = MarkSiteVisitViewModel();
  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';

  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null; // Remove the image
    });
  }

  @override
  void initState() {
    super.initState();
    _startFetchingLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Reporting'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Take Photos - Steps 4/4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Take Selfie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: _takePhoto,
              child: _image == null
                  ? Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.blueGrey,
                      size: 75,
                    )
                  : Image.file(
                      _image!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 5),
            GestureDetector(
                onTap: _deleteImage,
                child: Text(
                  'Delete',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )),
            SizedBox(height: 20),
            Text(
              'Take Equipment Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Photo 1',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: _image == null
                          ? Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.blueGrey,
                              size: 75,
                            )
                          : Image.file(
                              _image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text(
                                  'Are you sure you want to delete this image?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                        if (shouldDelete ?? false) {
                          _deleteImage();
                        }
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Photo 2',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: _image == null
                          ? Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.blueGrey,
                              size: 75,
                            )
                          : Image.file(
                              _image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                        onTap: _deleteImage,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Photo 3',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: _image == null
                          ? Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.blueGrey,
                              size: 75,
                            )
                          : Image.file(
                              _image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                        onTap: _deleteImage,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Photo 4',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: _image == null
                          ? Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.blueGrey,
                              size: 75,
                            )
                          : Image.file(
                              _image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: _deleteImage,
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Remark",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  String? token = await sessionManager.getToken();

                  MarkSiteVisitViewModel markSiteVisitViewModel =
                      MarkSiteVisitViewModel();
                  final String deviceDetails =
                      await Utils.getDeviceDetails(context);
                  final String appVersion = await Utils.getAppVersion();
                  final String ipAddress = await Utils.getIpAddress();
                  final int battery = await Utils.getBatteryLevel();

                  Map<String, dynamic> response =
                      await markSiteVisitViewModel.markMarkSiteVisit(
                          token!,
                          MarkSiteVisitModel(
                              clientSiteId: '',
                              checkListRes: '',
                              deviceDetails: deviceDetails,
                              deviceImei: '',
                              deviceIp: ipAddress,
                              siteName: '',
                              checkInTypeid: '',
                              locationID: '',
                              equipment: '',
                              scheduleDate: '',
                              isOffline: 'false',
                              version: appVersion,
                              locationName: '',
                              assetImg: '',
                              checkListComments: '',
                              checkListQuesId: '',
                              userImage: '',
                              batteryStatus: '$battery',
                              locationDetails: '$formattedSpeedValue/$formattedAccuracyValue',
                              time: '',
                              activityId: '',
                              latLong: formattedLatLng,
                              remarks: '',
                              dataUsage: ''));

                  if (response['code'] == 200) {
                    Navigator.of(context).pop();

                    QuickAlert.show(
                      confirmBtnText: 'Ok',
                      context: context,
                      type: QuickAlertType.success,
                      text: '${response['status']}',
                      onConfirmBtnTap: () {
                        Navigator.pushAndRemoveUntil(
                          this.context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${response['status']}')),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startFetchingLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Unable to fetch location. Please check and try again.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError("Location permissions are denied. Please allow them.");
        return;
      }
    }

    // Start fetching location updates
    Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        setState(() {
          formattedLatLng =
              "${position.latitude.toStringAsFixed(7)}, ${position.longitude.toStringAsFixed(7)}";
          formattedSpeedValue = "${position.speed.toStringAsFixed(2)} m/s";
          formattedAccuracyValue =
              "${position.accuracy.toStringAsFixed(2)} meters";
        });
      }
    }, onError: (error) {
      _showError("Failed to fetch location: $error");
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

// @override
// void dispose() {
//   super.dispose();
// }
