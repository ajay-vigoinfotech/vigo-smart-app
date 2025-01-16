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
import 'package:vigo_smart_app/core/strings/strings.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/home/view/home_page.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../markduty/viewmodel/get_current_date_view_model.dart';
import '../model/field_reporting_model.dart';
import '../view model/field_reporting_view_model.dart';
import '../view model/get_field_reporting_view_model.dart';

import 'dart:typed_data';
import 'package:image/image.dart' as img;

class FieldReporting extends StatefulWidget {
  const FieldReporting({super.key});

  @override
  State<FieldReporting> createState() => _FieldReportingState();
}

class _FieldReportingState extends State<FieldReporting>
    with SingleTickerProviderStateMixin {
  SessionManager sessionManager = SessionManager();
  GetFieldReportingViewModel getFieldReportingViewModel =
      GetFieldReportingViewModel();
  List<Map<String, dynamic>> getFieldReportingData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  String? savedImagePath;
  String? punchTimeDateIn;
  String timeDateDisplay = '';
  String uniqueIdv4 = '';
  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';
  String? dutyInRemark;
  String? inKm;

  bool isLoading = false;
  bool isCancelDisabled = false;

  late TabController _tabController;

  @override
  void initState() {
    _checkInternetConnection();
    _loadCurrentDateTime();
    _loadPunchInImageFromSP();
    _getPunchTimeDateInFromSP();
    fetchGetFieldReportingData();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleTabChange() async {
    if (_tabController.index == 1) {
      bool isConnected = await checkInternetConnection();
      if (!isConnected) {
        _tabController.index = 1;
      }
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.fieldReportingApp),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(child: Text('MARK PATROLLING')),
              Tab(child: Text('PUNCH HISTORY')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // MARK PATROLLING Tab Content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                    timeDateDisplay,
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
                      File(savedImagePath ?? ''),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterSearchResults,
                    decoration: InputDecoration(
                      hintText: "Search here",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshGetFieldReportingData,
                    child: filteredData.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildColumn(
                                        heading: data["dateTimeIn"],
                                        imageUrl:
                                            '${AppConstants.baseUrl}/${data["inPhoto"]}',
                                        //dateTime: data["dateTimeIn"],
                                        borderColor: Colors.green,
                                        location: data["location"],
                                        headingColor: Colors.green,
                                        remark: data["checkInRemarks"],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No records found',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onInButtonPressed() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) return;

    final ImagePicker picker = ImagePicker();
    final XFile? patrollingImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (patrollingImage != null) {
      final File image = File(patrollingImage.path);

      // Compress the image using the `image` package
      final img.Image? originalImage = img.decodeImage(image.readAsBytesSync());
      if (originalImage != null) {
        final img.Image resizedImage = img.copyResize(
          originalImage,
          width: 400,
          height: 400,
        );

        final Uint8List compressedBytes = Uint8List.fromList(
          img.encodeJpg(resizedImage, quality: 50),
        );

        // Convert the compressed image to Base64
        final String base64Image = base64Encode(compressedBytes);

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
                          Image.memory(
                            compressedBytes,
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
                              dutyInRemark = value;
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
                          onPressed: isCancelDisabled
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                },
                          child: const Text(
                            "Close",
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
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                          isCancelDisabled = true;
                                        });
                                        try {
                                          await _loadCurrentDateTime();
                                          punchTimeDateIn = timeDateDisplay;
                                          await _savePunchTimeDateInToSP(
                                              punchTimeDateIn!);
                                          await _saveImageToSP(
                                              patrollingImage.path);
                                          uniqueIdv4 = const Uuid().v4();

                                          String? token =
                                              await sessionManager.getToken();
                                          MarkFieldReportingViewModel
                                              markFieldReportingViewModel =
                                              MarkFieldReportingViewModel();
                                          final String deviceDetails =
                                              await Utils.getDeviceDetails(
                                                  context);
                                          final String appVersion =
                                              await Utils.getAppVersion();
                                          final String ipAddress =
                                              await Utils.getIpAddress();
                                          final String uniqueId =
                                              await Utils.getUniqueID();
                                          final int battery =
                                              await Utils.getBatteryLevel();

                                          String formatDate(String dateString) {
                                            DateFormat inputFormat = DateFormat(
                                                "dd/MM/yyyy hh:mm a");
                                            DateTime dateTime =
                                                inputFormat.parse(dateString);
                                            DateFormat outputFormat =
                                                DateFormat("yyyy-MM-dd HH:mm");
                                            return outputFormat
                                                .format(dateTime);
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
                                              remark: '$dutyInRemark',
                                              isOffline: 'false',
                                              version: appVersion,
                                              dataStatus: '',
                                              checkInId: uniqueIdv4,
                                              punchAction: 'IN',
                                              locationAccuracy:
                                                  formattedAccuracyValue,
                                              locationSpeed:
                                                  formattedSpeedValue,
                                              batteryStatus: '$battery',
                                              locationStatus: 'true',
                                              time: formattedDateTimeIn,
                                              latLong: formattedLatLng,
                                              kmsDriven: '0',
                                              siteId: '',
                                              locationId: '',
                                              distance: '',
                                            ),
                                          );

                                          if (response['code'] == 200) {
                                            Navigator.of(context).pop();

                                            QuickAlert.show(
                                              barrierDismissible: false,
                                              confirmBtnText: 'OK',
                                              confirmBtnTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 20),
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: '${response['status']}',
                                              onConfirmBtnTap: () {
                                                Navigator.pushAndRemoveUntil(this.context,
                                                  MaterialPageRoute(builder: (context) => HomePage()),
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
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text('Error: $error')),
                                          );
                                        } finally {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                child: const Text(
                                  "Submit",
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

  // Future<void> onInButtonPressed() async {
  //   bool isConnected = await checkInternetConnection();
  //   if (!isConnected) return;
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? patrollingImage = await picker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1920,
  //     maxHeight: 1080,
  //     // imageQuality: 20,
  //   );
  //
  //   if (patrollingImage != null) {
  //     final File image = File(patrollingImage.path);
  //
  //     final List<int>? compressedBytes = await FlutterImageCompress.compressWithFile(
  //       image.absolute.path,
  //       minWidth: 400,
  //       minHeight: 400,
  //       quality: 70, // Adjust compression quality
  //     );
  //
  //     if (compressedBytes != null) {
  //       final String base64Image = base64Encode(compressedBytes);
  //
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //               return AlertDialog(
  //                 title: const Center(child: Text("Mark Patrolling")),
  //                 content: SizedBox(
  //                   width: 800,
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Image.file(
  //                           image,
  //                           height: 125,
  //                           width: 125,
  //                         ),
  //                         const SizedBox(height: 3),
  //                         TextField(
  //                           maxLines: 1,
  //                           decoration: const InputDecoration(
  //                             hintText: "Enter comment",
  //                             border: OutlineInputBorder(),
  //                           ),
  //                           onChanged: (value) {
  //                             dutyInRemark = value;
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 actions: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.red,
  //                           foregroundColor: Colors.white,
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 20, vertical: 10),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.zero,
  //                           ),
  //                           elevation: 5,
  //                         ),
  //                         onPressed: () => Navigator.of(context).pop(),
  //                         child: const Text("Close",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 17,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ),
  //
  //                       isLoading
  //                           ? const CircularProgressIndicator()
  //                           : ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.green,
  //                           foregroundColor: Colors.white,
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 20, vertical: 10),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.zero,
  //                           ),
  //                           elevation: 5,
  //                         ),
  //
  //                         onPressed: isLoading
  //                             ? null
  //                             : () async {
  //                           setState(() {
  //                             isLoading = true;
  //                           });
  //                           try {
  //                             await _loadCurrentDateTime();
  //                             punchTimeDateIn = timeDateDisplay;
  //                             await _savePunchTimeDateInToSP(punchTimeDateIn!);
  //                             await _saveImageToSP(patrollingImage.path);
  //                             uniqueIdv4 = const Uuid().v4();
  //
  //                             String? token = await sessionManager.getToken();
  //                             MarkFieldReportingViewModel markFieldReportingViewModel = MarkFieldReportingViewModel();
  //                             final String deviceDetails = await Utils.getDeviceDetails(context);
  //                             final String appVersion = await Utils.getAppVersion();
  //                             final String ipAddress = await Utils.getIpAddress();
  //                             final String uniqueId = await Utils.getUniqueID();
  //                             final int battery = await Utils.getBatteryLevel();
  //
  //                             String formatDate(String dateString) {
  //                               DateFormat inputFormat = DateFormat("dd/MM/yyyy hh:mm a");
  //                               DateTime dateTime = inputFormat.parse(dateString);
  //                               DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm");
  //                               return outputFormat.format(dateTime);
  //                             }
  //
  //                             String formattedDateTimeIn = formatDate(punchTimeDateIn!);
  //
  //                             Map<String, dynamic> response = await markFieldReportingViewModel.markFieldReporting(
  //                               token!,
  //                               MarkFieldReportingModel(
  //                                 deviceDetails: deviceDetails,
  //                                 deviceImei: uniqueId,
  //                                 deviceIp: ipAddress,
  //                                 userPhoto: base64Image,
  //                                 remark: '$dutyInRemark',
  //                                 isOffline: 'false',
  //                                 version: appVersion,
  //                                 dataStatus: '',
  //                                 checkInId: uniqueIdv4,
  //                                 punchAction: 'IN',
  //                                 locationAccuracy: formattedAccuracyValue,
  //                                 locationSpeed: formattedSpeedValue,
  //                                 batteryStatus: '$battery',
  //                                 locationStatus: 'true',
  //                                 time: formattedDateTimeIn,
  //                                 latLong: formattedLatLng,
  //                                 kmsDriven: '0',
  //                                 siteId: '',
  //                                 locationId: '',
  //                                 distance: '',
  //                               ),
  //                             );
  //
  //                             if (response['code'] == 200) {
  //                               Navigator.of(context).pop();
  //
  //                               QuickAlert.show(
  //                                 barrierDismissible: false,
  //                                 confirmBtnText: 'OK',
  //                                 confirmBtnTextStyle: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: 20
  //                                 ),
  //                                 context: context,
  //                                 type: QuickAlertType.success,
  //                                 text: '${response['status']}',
  //                                 onConfirmBtnTap: () {
  //                                   Navigator.pushAndRemoveUntil(
  //                                     this.context,
  //                                     MaterialPageRoute(
  //                                         builder: (context) =>
  //                                             HomePage()),
  //                                         (route) => false,
  //                                   );
  //                                 },
  //                               );
  //
  //                               _loadPunchInImageFromSP();
  //                             } else {
  //                               ScaffoldMessenger.of(context)
  //                                   .showSnackBar(
  //                                 SnackBar(
  //                                     content: Text(
  //                                         'Error: ${response['status']}')),
  //                               );
  //                             }
  //                           } catch (error) {
  //                             ScaffoldMessenger.of(context)
  //                                 .showSnackBar(
  //                               SnackBar(
  //                                   content: Text('Error: $error')),
  //                             );
  //                           } finally {
  //                             setState(() {
  //                               isLoading = false;
  //                             });
  //                           }
  //                         },
  //                         child: const Text("Submit",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 17,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  Future<void> refreshGetFieldReportingData() async {
    await fetchGetFieldReportingData();
    debugPrint('Team Activity Patrolling List Data Refreshed');
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

  // Build the MapView with dynamic height
  Widget _buildMapView() {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width * 0.9,
      child: MapPage(
        locationReceived: _onLocationReceived,
        speedReceived: _onSpeedReceived,
        accuracyReceived: _onAccuracyReceived,
        isMapVisible: true,
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

  Widget _buildColumn({
    required String heading,
    required String imageUrl,
    required String? location,
    required Color borderColor,
    required Color headingColor,
    required String remark,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                heading,
                style: TextStyle(
                  color: headingColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(thickness: 2, color: Colors.black26),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/place_holder.webp'),
                        )
                      : Image.asset('assets/images/place_holder.webp'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location?.split('&').first ?? 'N/A',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remark,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchGetFieldReportingData() async {
    String? token = await getFieldReportingViewModel.sessionManager.getToken();

    if (token != null) {
      await getFieldReportingViewModel.fetchGetFieldReportingList(token);

      if (getFieldReportingViewModel.getFieldReportingList != null) {
        setState(() {
          getFieldReportingData =
              getFieldReportingViewModel.getFieldReportingList!
                  .map((entry) => {
                        'compId': entry.compId,
                        'dateTimeIn': entry.dateTimeIn,
                        'checkinTypeCode': entry.checkinTypeCode,
                        'inPhoto': entry.inPhoto,
                        'location': entry.location,
                        'checkInRemarks': entry.checkInRemarks,
                      })
                  .toList();
          filteredData = getFieldReportingData;
        });
      }
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = getFieldReportingData;
      });
    } else {
      setState(() {
        filteredData = getFieldReportingData.where((entry) {
          final dateTimeIn = entry['dateTimeIn']?.toLowerCase() ?? '';
          final inRemarks = entry['inRemarks']?.toLowerCase() ?? '';

          return dateTimeIn.contains(query.toLowerCase()) ||
              dateTimeIn.contains(query.toLowerCase()) ||
              inRemarks.contains(query.toLowerCase());
        }).toList();
      });
    }
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
}
