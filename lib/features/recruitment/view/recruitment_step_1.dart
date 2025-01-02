import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/create_recruitment_model.dart';
import 'package:vigo_smart_app/features/recruitment/view%20model/create_recruitment_view_model.dart';
import 'package:vigo_smart_app/features/recruitment/view%20model/designation_list_view_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_2.dart';
import 'package:vigo_smart_app/features/recruitment/widget/custom_text_form_field.dart';
import 'package:vigo_smart_app/features/recruitment/widget/gender_radio_button.dart';
import '../../../helper/toast_helper.dart';
import '../view model/branch_list_view_model.dart';
import '../view model/duplicate_aadhaar_view_model.dart';
import '../view model/site_list_view_model.dart';

class RecruitmentStep1 extends StatefulWidget {
  const RecruitmentStep1({super.key});

  @override
  State<RecruitmentStep1> createState() => _RecruitmentStep1State();
}

class _RecruitmentStep1State extends State<RecruitmentStep1> {
  bool _expandAll = true;
  String? _selectedStatus;

  final ImagePicker _picker = ImagePicker();
  String _digitalPhoto = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey<SfSignaturePadState>();
  bool _isSigned = false;
  late Uint8List _signatureData;
  late String _base64Signature = '';

  SessionManager sessionManager = SessionManager();

  String selectedSiteId = '';
  String selectedDesignationId = '';
  String selectedBranchId = '';

  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');


  @override
  void initState() {
    fetchSiteListData();
    fetchDesignationListData();
    fetchBranchListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 1'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _expandAll = !_expandAll;
              });
            },
            icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.article_sharp))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _aadhaarDetails(),
              _personalDetails(),
              _personalDocuments(),
              _deploymentDetails(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      try {
                        final validations = [
                          {aadhaarNo.isEmpty: "Please Enter Aadhaar number"},
                          {aadhaarNo.length != 12 : "Aadhaar number should be 12 digits"},
                          {panNo.isNotEmpty && !panRegex.hasMatch(panNo): "Please Enter a Valid Pan number"},
                          {_aadhaarImageFront.isEmpty: "Please upload Aadhaar proof side 1"},
                          {_aadhaarImageBack.isEmpty: "Please upload Aadhaar proof side 2"},
                          {firstName.isEmpty: "Please Enter First name"},
                          {mobNo.isEmpty: "Please Enter Mobile number"},
                          {mobNo.length != 10 : "Mobile number should be 10 digits"},
                          {dob.isEmpty : "Please select a DOB"},
                          {
                            dob.isNotEmpty && DateTime.tryParse(dob) != null && DateTime.now().difference(DateTime.parse(dob)).inDays < 6570:
                            "Employee is Minor"
                          },
                          {selectedGenderCode.isEmpty : 'Please Select a Gender' },
                          {selectedMaritalCode.isEmpty : 'Please Select Marital Status'},
                          {_digitalPhoto.isEmpty : 'Please take Employee Photo'},
                          {_base64Signature.isEmpty : 'Please insert Employee Signature'},
                        ];

                        for (var validation in validations) {
                          if (validation.keys.first) {
                            ToastHelper.showToast(message: validation.values.first);
                            return;
                          }
                        }

                        String? token = await sessionManager.getToken();
                        CreateRecruitmentViewModel createRecruitmentViewModel = CreateRecruitmentViewModel();

                        Map<String, dynamic> response = await createRecruitmentViewModel.createRecruitment(
                          token!,
                          CreateRecruitmentModel(
                            fullName: firstName,
                            lastName: lastName,
                            fatherName: fatherName,
                            motherName: motherName,
                            spouseName: spouseName,
                            contactNo: mobNo,
                            dob: dob,
                            gender: selectedGenderCode,
                            marritalStatus: selectedMaritalCode,
                            branchId: selectedBranchId,
                            siteId: selectedSiteId,
                            designationId: selectedDesignationId,
                            pan: panNo,
                            aadharno: aadhaarNo,
                            userImage: _digitalPhoto,
                            userSign: _base64Signature,
                            aadharFront: _aadhaarImageFront,
                            aadharBack: _aadhaarImageBack,
                          ),
                        );

                        if (response['code'] == 200) {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                            text: '${response['status']}',
                            onConfirmBtnTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                    RecruitmentStep2(userId: response['data'],
                                    ),
                                    ),
                                );
                            }
                          );
                        } else {
                          QuickAlert.show(
                            barrierDismissible: false,
                            confirmBtnText: 'Retry',
                            context: context,
                            type: QuickAlertType.error,
                            text: '${response['message'] ?? 'Something went wrong'}',
                          );
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('An error occurred. Please try again later.')),
                        );
                      }
                    },
                    child: Text(
                      'Submit and Next',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectSite() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 5,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  insetPadding: EdgeInsets.all(20),
                  child: StatefulBuilder(
                    builder: (dialogContext, setDialogState) => Container(
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        maxWidth: 500,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select Site',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                setDialogState(() {
                                  filterSiteListData = siteListData
                                      .where((site) =>
                                          site['unitName']
                                              ?.toLowerCase()
                                              .contains(value.toLowerCase()) ??
                                          false)
                                      .toList();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: filterSiteListData.isNotEmpty
                                ? ListView.separated(
                                    itemCount: filterSiteListData.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey.shade900,
                                      thickness: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index >= filterSiteListData.length) {
                                        return SizedBox.shrink();
                                      }
                                      final site = filterSiteListData[index];
                                      return ListTile(
                                        title: Text(site['unitName'] ?? ''),
                                        onTap: () {
                                          setState(() {
                                            selectedSite =
                                                site['unitName'] ?? '';
                                            selectedSiteId = site['siteId'];
                                          });
                                          Navigator.pop(context);
                                        },
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Text(
              selectedSite.isEmpty ? 'Select Site' : selectedSite,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectDesignation() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 5,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  insetPadding: EdgeInsets.all(20),
                  child: StatefulBuilder(
                    builder: (dialogContext, setDialogState) => Container(
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        maxWidth: 500,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select Designation',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                setDialogState(() {
                                  filterDesignationListData =
                                      designationListData
                                          .where((designation) =>
                                              designation['designationName']
                                                  ?.toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()) ??
                                              false)
                                          .toList();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: filterDesignationListData.isNotEmpty
                                ? ListView.separated(
                                    itemCount: filterDesignationListData.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey.shade900,
                                      thickness: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index >=
                                          filterDesignationListData.length) {
                                        return SizedBox.shrink();
                                      }
                                      final designation =
                                          filterDesignationListData[index];
                                      return ListTile(
                                        title: Text(
                                            designation['designationName'] ??
                                                ''),
                                        onTap: () {
                                          setState(() {
                                            selectedDesignation = designation[
                                                    'designationName'] ??
                                                '';
                                            selectedDesignationId =
                                                designation['designationId'];
                                          });
                                          Navigator.pop(context);
                                        },
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Text(
              selectedDesignation.isEmpty
                  ? 'Select Designation.'
                  : selectedDesignation,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectBranch() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 5,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  insetPadding: EdgeInsets.all(20),
                  child: StatefulBuilder(
                    builder: (dialogContext, setDialogState) => Container(
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        maxWidth: 500,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select Branch',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                setDialogState(() {
                                  filterBranchListData = branchListData
                                      .where((branch) =>
                                          branch['branchName']
                                              ?.toLowerCase()
                                              .contains(value.toLowerCase()) ??
                                          false)
                                      .toList();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: filterBranchListData.isNotEmpty
                                ? ListView.separated(
                                    itemCount: filterBranchListData.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey.shade900,
                                      thickness: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index >=
                                          filterBranchListData.length) {
                                        return SizedBox.shrink();
                                      }
                                      final branch =
                                          filterBranchListData[index];
                                      return ListTile(
                                        title: Text(branch['branchName'] ?? ''),
                                        onTap: () {
                                          setState(() {
                                            selectedBranch =
                                                branch['branchName'] ?? '';
                                            selectedBranchId = branch[''] ?? '';
                                          });
                                          Navigator.pop(context);
                                        },
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Text(
              selectedBranch.isEmpty ? 'Select Branch' : selectedBranch,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  bool _handleOnDrawStart() {
    _isSigned = true;
    return false;
  }

  void _handleClearButtonPressed() {
    _signaturePadKey.currentState?.clear();
    _isSigned = false;
  }

  Future<void> _handleSaveButtonPressed() async {
    try {
      final ui.Image image =
          await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);

      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List data = byteData.buffer.asUint8List();
        final String base64Image = base64Encode(data);

        setState(() {
          _signatureData = data;
          _base64Signature = base64Image;
          _isSigned = true;
        });
        // debugPrint("Signature saved successfully!");
      } else {
        throw Exception("Failed to convert signature to PNG data.");
      }
    } catch (e) {
      debugPrint("Error saving signature: $e");
    }
  }

  void _showPopup() {
    showDialog<Widget>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            final Color textColor = Colors.black87;

            return AlertDialog(
              insetPadding: const EdgeInsets.all(12),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Draw your signature',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear, size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // width: MediaQuery.of(context).size.width < 306
                        //     ? MediaQuery.of(context).size.width
                        //     : 450,
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: SfSignaturePad(
                          minimumStrokeWidth: 5.0,
                          maximumStrokeWidth: 5.0,
                          strokeColor: Colors.black,
                          backgroundColor: Colors.white,
                          onDrawStart: _handleOnDrawStart,
                          key: _signaturePadKey,
                        ),
                      ),
                      Text('I agree to the terms and conditions.')
                    ],
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              actionsPadding: const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _handleClearButtonPressed();
                  },
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium'),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _handleSaveButtonPressed();
                    Navigator.of(context).pop();
                  },
                  child: const Text('SAVE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _getBottomView() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _showPopup();
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: _isSigned
                ? Image.memory(
                    _signatureData,
                    width: 500,
                    height: 500,
                    fit: BoxFit.contain,
                  )
                : Center(
                    child: Text(
                      'Tap here to sign',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage(String type) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How do you want to select image.'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                if (type == 'digital_photo') {
                  await _pickAndCropImage(type, ImageSource.camera);
                } else {
                  await _pickImage(type, ImageSource.camera);
                }
              },
            ),
            ListTile(
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                if (type == 'digital_photo') {
                  await _pickAndCropImage(type, ImageSource.gallery);
                } else {
                  await _pickImage(type, ImageSource.gallery);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(String type, ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      final File selectedFile = File(photo.path);

      final compressedImage = await FlutterImageCompress.compressWithFile(
        selectedFile.path,
        minWidth: 300,
        minHeight: 300,
        quality: 80,
      );

      if (compressedImage != null) {
        final base64String = base64Encode(compressedImage);

        setState(() {
          if (type == 'front') {
            _aadhaarImageFront = base64String;
          } else if (type == 'back') {
            _aadhaarImageBack = base64String;
          }
        });
      }
    }
  }

  Future<void> _pickAndCropImage(String type, ImageSource source) async {
    // Pick an image using the selected source
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      // Crop the selected image
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path,
        uiSettings: [
          IOSUiSettings(
            title: 'Edit Photo',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        final File croppedImageFile = File(croppedFile.path);
        final compressedImage = await FlutterImageCompress.compressWithFile(
          croppedImageFile.path,
          minWidth: 300, // Adjust resolution
          minHeight: 300,
          quality: 80,
        );

        if (compressedImage != null) {
          final base64String = base64Encode(compressedImage);

          setState(() {
            if (type == 'digital_photo') {
              _digitalPhoto = base64String;
            }
          });
        }
      }
    }
  }

  void _deleteImage(String type) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            type == 'front'
                ? 'Are you sure you want to delete the front image?'
                : type == 'back'
                    ? 'Are you sure you want to delete the back image?'
                    : 'Are you sure you want to delete the digital photo?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      setState(() {
        if (type == 'front') {
          _aadhaarImageFront = '';
        } else if (type == 'back') {
          _aadhaarImageBack = '';
        } else if (type == 'digital_photo') {
          _digitalPhoto = '';
        }
      });
    }
  }

  //Aadhaar details
  String aadhaarNo = '';
  String panNo = '';
  String _aadhaarImageFront = '';
  String _aadhaarImageBack = '';

  Widget _aadhaarDetails() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Row(
            children: [
              Text('Aadhaar Details'),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Aadhaar Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.green,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          controller: aadhaarController,
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Aadhaar No*'),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: isDuplicate
                                ? Tooltip(
                                    message: errorMessage,
                                    child: Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                    ),
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            validateAadhaarNumber(value);
                            aadhaarNo = value;
                            debugPrint(aadhaarNo);
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  // PAN Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('PAN No'),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            panNo = value;
                            debugPrint(panNo);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Z0-9]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Aadhaar Proof (Front/Back)
                  Text(
                    'Aadhaar Proof (Front/Back)',
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _selectImage('front'),
                            child: _aadhaarImageFront.isEmpty
                                ? Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 50,
                                  )
                                : Image.memory(
                                    base64Decode(_aadhaarImageFront),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          GestureDetector(
                            onTap: () => _deleteImage('front'),
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _selectImage('back'), // Back Image
                            child: _aadhaarImageBack.isEmpty
                                ? Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 50,
                                  )
                                : Image.memory(
                                    base64Decode(_aadhaarImageBack),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          GestureDetector(
                            onTap: () => _deleteImage('back'),
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Personal Details
  String firstName = '';
  String lastName = '';
  String fatherName = '';
  String motherName = '';
  String spouseName = '';
  String mobNo = '';
  String dob = '';
  String selectedGenderCode = '';
  String selectedMaritalCode = '';

  final Map<String, String> statusCodes = {
    'Married': '1',
    'Unmarried': '2',
    'Separated': '3',
    'Widow': '4',
  };

  void handleGenderSelected(int genderCode) {
    setState(() {
      selectedGenderCode = genderCode.toString();
    });
  }

  Widget _personalDetails() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text('Personal Information'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Name (As Per Aadhaar)',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      firstName = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Last Name',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      lastName = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: "Father's Name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      fatherName = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: "Mother's Name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      motherName = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: "Spouse's Name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      spouseName = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.call,
                    maxLength: 10,
                    labelText: "Mobile No",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      mobNo = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.calendar_month,
                    labelText: 'DOB',
                    isDatePicker: true,
                    controller: dateController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd-MM-yyyy');
                            final parsedDate = inputFormat.parse(value);

                            final outputFormat = DateFormat('yyyy-MM-dd');
                            dob = outputFormat.format(parsedDate);

                            dateController.text = value;
                          } catch (e) {
                            debugPrint('Error parsing date: $e');
                          }
                        }
                      });
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Gender *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  GenderRadioButtons(onGenderSelected: handleGenderSelected),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Marital Status',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedStatus,
                          hint: const Text(
                            'Select Marital Status',
                            style: TextStyle(color: Colors.black54),
                          ),
                          items: <String>[
                            'Married',
                            'Unmarried',
                            'Separated',
                            'Widow'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                              selectedMaritalCode = statusCodes[newValue] ?? '';
                            });
                          },
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Personal Documents

  Widget _personalDocuments() {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text('Personal Documents'),
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Digital Photo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _selectImage('digital_photo'),
                        child: _digitalPhoto.isEmpty
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 100,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/user_camera.png',
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 100,
                                child: ClipOval(
                                  child: Image.memory(
                                    base64Decode(_digitalPhoto),
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Digital Signature',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: _getBottomView()),
                TextButton(
                  onPressed: () {
                    _showValidationDialog();
                    debugPrint('Signature removed');
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Signature'),
        content: const Text('Are you sure you want to remove the signature'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _signaturePadKey.currentState?.clear();
                _isSigned = false;
                // _signatureData = Uint8List(0);
              });
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _deploymentDetails() {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text('Deployment Details'),
          children: <Widget>[
            _selectSite(),
            _selectDesignation(),
            _selectBranch(),
          ],
        ),
      ),
    );
  }

  // Get Assign Site List
  SiteListViewModel siteListViewModel = SiteListViewModel();
  List<Map<String, dynamic>> siteListData = [];
  List<Map<String, dynamic>> filterSiteListData = [];
  String selectedSite = '';

  Future<void> fetchSiteListData() async {
    String? token = await siteListViewModel.sessionManager.getToken();
    if (token != null) {
      await siteListViewModel.fetchAssignSiteList(token);

      setState(() {
        if (siteListViewModel.assignSiteList != null) {
          siteListData = siteListViewModel.assignSiteList!
              .map((entry) => {
                    "siteId": entry.siteId,
                    "compID": entry.compID,
                    "clientId": entry.clientId,
                    "siteName": entry.siteName,
                    "siteCode": entry.siteCode,
                    "unitName": entry.unitName,
                    "clientName": entry.clientName,
                  })
              .toList();
        }
      });
      setState(() {
        filterSiteListData = siteListData;
      });
    }
  }

  // Get Designation List
  DesignationListViewModel designationListViewModel =
      DesignationListViewModel();
  List<Map<String, dynamic>> designationListData = [];
  List<Map<String, dynamic>> filterDesignationListData = [];
  String selectedDesignation = '';

  Future<void> fetchDesignationListData() async {
    String? token = await designationListViewModel.sessionManager.getToken();
    if (token != null) {
      await designationListViewModel.fetchAssignDesignationList(token);

      setState(() {
        if (designationListViewModel.assignDesignationList != null) {
          designationListData = designationListViewModel.assignDesignationList!
              .map((entry) => {
                    "designationId": entry.designationId,
                    "designationCode": entry.designationCode,
                    "designationName": entry.designationName,
                  })
              .toList();
        }
      });
      setState(() {
        filterDesignationListData = designationListData;
      });
    }
  }

  //Get Branch List
  BranchListViewModel branchListViewModel = BranchListViewModel();
  List<Map<String, dynamic>> branchListData = [];
  List<Map<String, dynamic>> filterBranchListData = [];
  String selectedBranch = '';

  Future<void> fetchBranchListData() async {
    String? token = await branchListViewModel.sessionManager.getToken();
    if (token != null) {
      await branchListViewModel.fetchAssignBranchList(token);

      setState(() {
        if (branchListViewModel.assignBranchList != null) {
          branchListData = branchListViewModel.assignBranchList!
              .map((entry) => {
                    "branchId": entry.branchId,
                    "compId": entry.compId,
                    "branchName": entry.branchName,
                    "branchCode": entry.branchCode,
                    "branchAddress": entry.branchAddress,
                    "empBranchCode": entry.empBranchCode,
                    "createdBy": entry.createdBy,
                    "createdAt": entry.createdAt,
                    "modifiedBy": entry.modifiedBy,
                    "modifiedAt": entry.modifiedAt,
                    "isVisible": entry.isVisible,
                  })
              .toList();
        }
      });
      setState(() {
        filterBranchListData = branchListData;
      });
    }
  }

  // Check Duplicate Aadhaar
  final TextEditingController aadhaarController = TextEditingController();
  bool isDuplicate = false;
  String errorMessage = '';

  DuplicateAadhaarViewModel duplicateAadhaarViewModel =
      DuplicateAadhaarViewModel();
  void validateAadhaarNumber(String aadhaarNo) async {
    if (aadhaarNo.length == 12) {
      String? token = await duplicateAadhaarViewModel.sessionManager.getToken();
      if (token != null) {
        bool duplicateCheck = await duplicateAadhaarViewModel
            .fetchDuplicateAadhaarList(token, aadhaarNo);

        setState(() {
          isDuplicate = duplicateCheck;
          errorMessage = duplicateCheck ? 'Already exists: $aadhaarNo' : '';
        });

        if (duplicateCheck) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Duplicate Aadhaar Found!'),
              content: Text('The Aadhaar number $aadhaarNo already exists.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green.shade700,
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'The Aadhaar number is valid.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    } else {
      setState(() {
        isDuplicate = false;
        errorMessage = '';
      });
    }
  }
}
