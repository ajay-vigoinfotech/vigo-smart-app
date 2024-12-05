import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../../../core/utils.dart';
import '../../home/view/home_page.dart';
import '../../markduty/viewmodel/get_current_date_view_model.dart';
import '../model/mark_site_visit_model.dart';
import '../view model/mark_site_visit_view_model.dart';

class SiteReportingStep4 extends StatefulWidget {
  final dynamic value;
  final dynamic text;
  final dynamic siteId;
  final String activityId;
  final List<String> questionIds;
  final List<String> selectedOptions;
  final List<String> comments;

  const SiteReportingStep4({
    super.key,
    required this.value,
    required this.text,
    required this.activityId,
    required this.questionIds,
    required this.selectedOptions,
    required this.comments,
    required this.siteId,
  });

  @override
  State<SiteReportingStep4> createState() => _SiteReportingStep4State();
}

class _SiteReportingStep4State extends State<SiteReportingStep4> {
  SessionManager sessionManager = SessionManager();
  MarkSiteVisitViewModel markSiteVisitViewModel = MarkSiteVisitViewModel();
  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';
  String timeDateDisplay = '';
  String punchTimeDateIn = '';
  String dutyInRemark = '';

  final ImagePicker _picker = ImagePicker();
  File? _userImage;
  File? _assetImage1;
  File? _assetImage2;
  File? _assetImage3;
  File? _assetImage4;

  String _base64UserImage = '';
  String _base64AssetImage1 = '';
  String _base64AssetImage2 = '';
  String _base64AssetImage3 = '';
  String _base64AssetImage4 = '';

  @override
  void initState() {
    super.initState();
    _startFetchingLocation();
    _loadCurrentDateTime();
  }

  Future<void> _takePhoto(int imageNumber) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final selectedFile = File(photo.path);
      final compressedImage = await FlutterImageCompress.compressWithFile(
        selectedFile.path,
        minWidth: 100,
        minHeight: 100,
        quality: 100,
      );

      if (compressedImage != null) {
        final base64String = base64Encode(compressedImage);

        setState(() {
          switch (imageNumber) {
            case 1:
              _userImage = selectedFile;
              _base64UserImage = base64String;
              break;
            case 2:
              _assetImage1 = selectedFile;
              _base64AssetImage1 = base64String;
              break;
            case 3:
              _assetImage2 = selectedFile;
              _base64AssetImage2 = base64String;
              break;
            case 4:
              _assetImage3 = selectedFile;
              _base64AssetImage3 = base64String;
              break;
            case 5:
              _assetImage4 = selectedFile;
              _base64AssetImage4 = base64String;
              break;
          }
        });
      }
    }
  }

  void _deleteImage(BuildContext context, int imageNumber) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      setState(() {
        switch (imageNumber) {
          case 1:
            _userImage = null;
            _base64UserImage = '';
            break;
          case 2:
            _assetImage1 = null;
            _base64AssetImage1 = '';
            break;
          case 3:
            _assetImage2 = null;
            _base64AssetImage2 = '';
            break;
          case 4:
            _assetImage3 = null;
            _base64AssetImage3 = '';
            break;
          case 5:
            _assetImage4 = null;
            _base64AssetImage4 = '';
            break;
        }
      });
    }
  }

  Widget _buildImagePicker(int imageNumber, File? imageFile) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _takePhoto(imageNumber),
          child: imageFile == null
              ? Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.blueGrey,
                  size: 75,
                )
              : Image.file(
                  imageFile,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () => _deleteImage(context, imageNumber),
          child: Text(
            'Delete',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ],
    );
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
            _buildImagePicker(1, _userImage),
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
                    _buildImagePicker(2, _assetImage1),
                    SizedBox(height: 5),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Photo 2',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    _buildImagePicker(3, _assetImage2),
                    SizedBox(height: 5),
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
                    _buildImagePicker(4, _assetImage3),
                    SizedBox(height: 5),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Photo 4',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    _buildImagePicker(5, _assetImage4),
                    SizedBox(height: 5),
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
                onChanged: (value) {
                  dutyInRemark = value;
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_base64UserImage.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please take Selfie!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  if (_base64AssetImage1.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please add minimum 1 equipment photo!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  if (formattedLatLng.isEmpty) {
                    Fluttertoast.showToast(
                      msg:
                          "Unable to fetch location, Please check and try again!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  String combinedValue = '${widget.value}${widget.siteId}';

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black.withOpacity(0.5),
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                                strokeWidth: 3.0,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Please wait..',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  await _loadCurrentDateTime();
                  punchTimeDateIn = timeDateDisplay;
                  String? token = await sessionManager.getToken();
                  MarkSiteVisitViewModel markSiteVisitViewModel =
                      MarkSiteVisitViewModel();
                  final String deviceDetails =
                      await Utils.getDeviceDetails(context);
                  final String appVersion = await Utils.getAppVersion();
                  final String ipAddress = await Utils.getIpAddress();
                  final String uniqueId = await Utils.getUniqueID();
                  final int battery = await Utils.getBatteryLevel();

                  String assetImgString = '';
                  if (_base64AssetImage1.isNotEmpty) {
                    assetImgString = _base64AssetImage1;
                  }
                  if (_base64AssetImage2.isNotEmpty) {
                    assetImgString +=
                        (assetImgString.isEmpty ? '' : '*assetImg*') +
                            _base64AssetImage2;
                  }
                  if (_base64AssetImage3.isNotEmpty) {
                    assetImgString +=
                        (assetImgString.isEmpty ? '' : '*assetImg*') +
                            _base64AssetImage3;
                  }
                  if (_base64AssetImage4.isNotEmpty) {
                    assetImgString +=
                        (assetImgString.isEmpty ? '' : '*assetImg*') +
                            _base64AssetImage4;
                  }

                  String formatDate(String dateString) {
                    DateFormat inputFormat = DateFormat("dd/MM/yyyy hh:mm a");
                    DateTime dateTime = inputFormat.parse(dateString);
                    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm");
                    return outputFormat.format(dateTime);
                  }

                  String formattedDateTimeIn = formatDate(punchTimeDateIn);

                  Map<String, dynamic> response =
                      await markSiteVisitViewModel.markMarkSiteVisit(
                          token!,
                          MarkSiteVisitModel(
                              clientSiteId: combinedValue,
                              checkListRes: widget.selectedOptions.join(','),
                              deviceDetails: deviceDetails,
                              deviceImei: uniqueId,
                              deviceIp: ipAddress,
                              siteName: widget.text,
                              checkInTypeid: '8',
                              locationID: '-',
                              equipment: '-',
                              scheduleDate: '-',
                              isOffline: 'false',
                              version: appVersion,
                              locationName: '-',
                              assetImg: assetImgString,
                              checkListComments: widget.comments.join('*,*'),
                              checkListQuesId: widget.questionIds.join(','),
                              userImage: _base64UserImage,
                              batteryStatus: '$battery',
                              locationDetails:
                                  '$formattedSpeedValue/$formattedAccuracyValue',
                              time: formattedDateTimeIn,
                              activityId: widget.activityId,
                              latLong: formattedLatLng,
                              remarks: dutyInRemark,
                              dataUsage: '-'));

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
                    SnackBar(content: Text('Error::: $error')),
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
            SizedBox(height: 30),
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

  void _startFetchingLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: "Unable to fetch location, Please check and try again!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

    Geolocator.getPositionStream().listen((Position position) {
      if (mounted) {
        setState(() {
          formattedLatLng =
              "${position.latitude.toStringAsFixed(7)}, ${position.longitude.toStringAsFixed(7)}";
          formattedSpeedValue = position.speed.toStringAsFixed(2);
          formattedAccuracyValue = position.accuracy.toStringAsFixed(2);
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
