import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/create_recruitment_model.dart';
import 'package:vigo_smart_app/features/recruitment/view%20model/create_recruitment_view_model.dart';
import 'package:vigo_smart_app/features/recruitment/view%20model/designation_list_view_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/pre_recruitment_list.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_2.dart';
import 'package:vigo_smart_app/features/recruitment/widget/custom_text_form_field.dart';
import 'package:vigo_smart_app/features/recruitment/widget/gender_radio_button.dart';
import '../../../helper/toast_helper.dart';
import '../model/update_recruitment01_model.dart';
import '../view model/branch_list_view_model.dart';
import '../view model/duplicate_aadhaar_view_model.dart';
import '../view model/pre_recruitment_by_id_view_model.dart';
import '../view model/site_list_view_model.dart';
import '../view model/update_recruitment01_view_model.dart';
import 'package:image/image.dart' as img;

class RecruitmentStep1 extends StatefulWidget {
  final dynamic recruitedUserId;
  const RecruitmentStep1({super.key, required this.recruitedUserId});

  @override
  State<RecruitmentStep1> createState() => _RecruitmentStep1State();
}

class _RecruitmentStep1State extends State<RecruitmentStep1> {
  String? userId;
  String? recruitedUserId;

  bool _expandAll = true;
  String? _selectedStatus;

  final ImagePicker _picker = ImagePicker();
  String _digitalPhoto = '';

  final TextEditingController nameController = TextEditingController();

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey<SfSignaturePadState>();
  bool _isSigned = false;
  late Uint8List _signatureData;
  late String _base64Signature = '';

  SessionManager sessionManager = SessionManager();

  String selectedSiteId = '';
  String selectedSiteName = '';
  String selectedDesignationId = '';
  String selectedDesignationName = '';
  String selectedBranchId = '';

  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  TextEditingController aadharNumController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController spouseNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController marritalStatusController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController signatureController = TextEditingController();
  TextEditingController aadhaar1DocController = TextEditingController();
  TextEditingController aadhaar2DocController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController siteIdController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController designationIdController = TextEditingController();
  TextEditingController designationNameController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recruitedUserId != null) {
      fetchPreRecruitmentByIdData().then((_) {
        fetchSiteListData().then((_) {
          fetchDesignationListData().then((_) {
            fetchBranchListData().then((_) {});
          });
        });
      });
    } else if (userId != null) {
      fetchSiteListData();
      fetchDesignationListData();
      fetchBranchListData();
    }
  }

  //PreRecruitment By ID
  PreRecruitmentByIdViewModel preRecruitmentByIdViewModel = PreRecruitmentByIdViewModel();
  List<Map<String, dynamic>> preRecruitmentByIdData = [];

  String formatDate(String date, {String inputFormat = 'dd-MM-yyyy', String outputFormat = 'yyyy-MM-dd'}) {
    try {
      final inputFormatter = DateFormat(inputFormat);
      final outputFormatter = DateFormat(outputFormat);
      final parsedDate = inputFormatter.parse(date);
      return outputFormatter.format(parsedDate);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return date;
    }
  }

  Future<void> fetchPreRecruitmentByIdData() async {
    String? token = await preRecruitmentByIdViewModel.sessionManager.getToken();

    if (token != null) {
      await preRecruitmentByIdViewModel.fetchPreRecruitmentByIdList(token, widget.recruitedUserId);

      if (preRecruitmentByIdViewModel.getPreRecruitmentByIdList != null) {
        setState(() {
          preRecruitmentByIdData = preRecruitmentByIdViewModel.getPreRecruitmentByIdList!
                  .map((entry) => {
                        "userId": entry.userId,
                        "aadharNum": entry.aadharNum,
                        "pan": entry.pan,
                        "aadhaarDocs": entry.aadhaarDocs,
                        "fullName": entry.fullName,
                        "firstName": entry.firstName,
                        "lastName": entry.lastName,
                        "fatherName": entry.fatherName,
                        "motherName": entry.motherName,
                        "spouseName": entry.spouseName,
                        "mobilePIN": entry.mobilePIN,
                        "image": entry.image,
                        "signature": entry.signature,
                        "dob": entry.dob,
                        "gender": entry.gender,
                        "marritalStatus": entry.marritalStatus,
                        "siteId": entry.siteId,
                        "siteCode": entry.siteCode,
                        "siteName": entry.siteName,
                        "designationId" : entry.designationId,
                        "designationName": entry.designationName,
                        "branch": entry.branch,
                      })
                  .toList();

          if (preRecruitmentByIdData.isNotEmpty) {
            //aadhaar details
            aadhaarNo = preRecruitmentByIdData[0]["aadharNum"] ?? "";
            aadharNumController.text = aadhaarNo;
            panNo = preRecruitmentByIdData[0]["pan"];
            panController.text = panNo;

            //Aadhaar Images(Font/Back)
            String aadhaarDocs = preRecruitmentByIdData[0]["aadhaarDocs"] ?? "";
            List<String> aadhaarDocsList = aadhaarDocs.split('#*#');
            String aadhar1 = aadhaarDocsList.isNotEmpty ? aadhaarDocsList[0] : "";
            String aadhar2 = aadhaarDocsList.isNotEmpty ? aadhaarDocsList[1] : "";
            aadhaar1DocController.text = aadhar1;
            aadhaar2DocController.text = aadhar2;
            aadhar1 = _aadhaarImageFront;
            aadhar2 = _aadhaarImageBack;

            //personal information
            firstName = preRecruitmentByIdData[0]["fullName"];
            firstNameController.text = firstName;
            lastName = preRecruitmentByIdData[0]["lastName"];
            lastNameController.text = lastName;
            fatherName = preRecruitmentByIdData[0]["fatherName"];
            fatherNameController.text = fatherName;
            motherName = preRecruitmentByIdData[0]["motherName"];
            motherNameController.text = motherName;
            spouseName = preRecruitmentByIdData[0]["spouseName"];
            spouseNameController.text = spouseName;
            mobNo = preRecruitmentByIdData[0]["mobilePIN"] ?? "";
            mobileNoController.text = mobNo;

            dob = preRecruitmentByIdData[0]["dob"] ?? "";
            dob = formatDate(dob);
            dobController.text = formatDate(dob, inputFormat: 'yyyy-MM-dd', outputFormat: 'dd-MM-yyyy');

            selectedGenderCode = preRecruitmentByIdData[0]["gender"] ?? "";
            genderController.text = selectedGenderCode;
            selectedGenderCode == '1' ? 'Male' : 'Female';
            selectedMaritalCode = preRecruitmentByIdData[0]["marritalStatus"] ?? "";
            marritalStatusController.text = selectedMaritalCode;
            marritalStatusController.text = preRecruitmentByIdData[0]["marritalStatus"] ?? "";
            String apiMaritalCode = preRecruitmentByIdData[0]["marritalStatus"] ?? "";
            _selectedStatus = statusCodes.entries
                .firstWhere(
                  (entry) => entry.value == apiMaritalCode,
              orElse: () => const MapEntry('', ''),
            )
                .key;

            //personal documents
            imageController.text = preRecruitmentByIdData[0]["image"] ?? "";
            _base64Signature = preRecruitmentByIdData[0]["signature"] ?? "";
            signatureController.text = _base64Signature;

            //deployment details
            selectedSiteId = preRecruitmentByIdData[0]["siteId"] ?? "";
            siteIdController.text = selectedSiteId;

            selectedSiteName = preRecruitmentByIdData[0]["siteName"] ?? "";
            siteNameController.text = selectedSiteName;

            selectedDesignationId = preRecruitmentByIdData[0]["designationId"] ?? "";
            designationIdController.text = selectedDesignationId;

            selectedDesignationName = preRecruitmentByIdData[0]["designationName"] ?? "";
            designationNameController.text = selectedDesignationName;

            branchController.text = preRecruitmentByIdData[0]["branch"] ?? "";
            userIdController.text = preRecruitmentByIdData[0]["userId"] ?? "";
            recruitedUserId = preRecruitmentByIdData[0]["userId"] ?? "";
          }
        });
      }
    }
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
          if (widget.recruitedUserId == null || widget.recruitedUserId.isEmpty)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreRecruitmentList()),
                );
              },
              icon: Icon(Icons.article_sharp),
            ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
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
                              {aadhaarNo.length != 12: "Aadhaar number should be 12 digits"},
                              {panNo.isNotEmpty && !panRegex.hasMatch(panNo): "Please Enter a Valid Pan number"},
                              {_aadhaarImageFront.isEmpty && aadhaar1DocController.text.isEmpty: "Please upload Aadhaar proof side 1"},
                              {_aadhaarImageBack.isEmpty && aadhaar2DocController.text.isEmpty: "Please upload Aadhaar proof side 2"},
                              {firstName.isEmpty: "Please Enter First name"},
                              {mobNo.isEmpty: "Please Enter Mobile number"},
                              {mobNo.length != 10: "Mobile number should be 10 digits"},
                              {dob.isEmpty: "Please select a DOB"},
                              {dob.isNotEmpty &&
                                  DateTime.tryParse(dob) != null &&
                                  DateTime.now().difference(DateTime.parse(dob)).inDays < 6570: "Employee is Minor"},
                              {selectedGenderCode.isEmpty: 'Please Select a Gender'},
                              {selectedMaritalCode.isEmpty: 'Please Select Marital Status'},
                              {_digitalPhoto.isEmpty && imageController.text.isEmpty: 'Please take Employee Photo'},
                              {_base64Signature.isEmpty && signatureController.text.isEmpty: 'Please insert Employee Signature'},
                            ];

                            for (var validation in validations) {
                              if (validation.keys.first) {
                                ToastHelper.showToast(message: validation.values.first, context: context);
                                return;
                              }
                            }

                            String? token = await sessionManager.getToken();

                            if ((userId == null || userId!.isEmpty) && (widget.recruitedUserId == null || widget.recruitedUserId.isEmpty)) {
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
                                  dob: dob ,
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
                                setState(() {
                                  userId = response['data'];
                                });
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: '${response['status']}',
                                  onConfirmBtnTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecruitmentStep2(
                                          userId: response['data'],
                                        ),
                                      ),
                                    );
                                  },
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
                            } else {
                              UpdateRecruitment01ViewModel updateRecruitment01ViewModel = UpdateRecruitment01ViewModel();
                              Map<String, dynamic> response = await updateRecruitment01ViewModel.updateRecruitment01(
                                token!,
                                UpdateRecruitment01Model(
                                  userId: userId ?? widget.recruitedUserId,
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
                                  barrierDismissible: false,
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: response['status'],
                                  onConfirmBtnTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecruitmentStep2(
                                          userId: userId ,
                                          recruitedUserId : widget.recruitedUserId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: response['message'] ?? 'Something went wrong',
                                );
                              }
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
                  if (widget.recruitedUserId != null && widget.recruitedUserId.isNotEmpty) SizedBox(width: 10),
                  if (widget.recruitedUserId != null && widget.recruitedUserId.isNotEmpty)
                    ElevatedButton(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecruitmentStep2(
                              userId: userId,
                              recruitedUserId : widget.recruitedUserId,
                            ),
                          ),
                        );
                      },
                      child: Text('Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                ],
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
                                            selectedSite = site['unitName'];
                                            selectedSiteId = site['siteId'] ;
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
              selectedSite.isNotEmpty
                  ? selectedSite
                  : (selectedSiteName.isNotEmpty
                      ? selectedSiteName
                      : 'Select Site'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                                      final designation = filterDesignationListData[index];
                                      return ListTile(
                                        title: Text(designation['designationName'] ?? ''),
                                        onTap: () {
                                          setState(() {
                                            selectedDesignation = designation['designationName'];
                                            selectedDesignationId = designation['designationId'];
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
              selectedDesignation.isNotEmpty
                  ? selectedDesignation
                  : (selectedDesignationName.isNotEmpty
                      ? selectedDesignationName
                      : 'Select Designation'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // child: Text(
            //   selectedDesignation.isEmpty
            //       ? 'Select Designation.'
            //       : selectedDesignation,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //   ),
            //   maxLines: 1,
            // ),
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
                                            selectedBranch = branch['branchName'] ?? '';
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
              selectedBranch.isNotEmpty
                  ? selectedBranch
                  : (branchController.text.isNotEmpty
                      ? branchController.text
                      : 'Select Branch'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // child: Text(
            //   selectedBranch.isEmpty ? 'Select Branch' : selectedBranch,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //   ),
            //   maxLines: 1,
            // ),
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
    setState(() {
      _isSigned = false;
      _signatureData = Uint8List(0); // Reset the signature data to an empty value
      _base64Signature = ''; // Clear the base64 signature
    });
    debugPrint('Signature removed');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signature removed successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }


  // void _handleClearButtonPressed() {
  //   _signaturePadKey.currentState?.clear();
  //   _isSigned = false;
  // }

  // Future<void> _handleSaveButtonPressed() async {
  //   try {
  //     final ui.Image image =
  //         await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
  //
  //     final ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     if (byteData != null) {
  //       final Uint8List data = byteData.buffer.asUint8List();
  //       final String base64Image = base64Encode(data);
  //
  //       setState(() {
  //         _signatureData = data;
  //         _base64Signature = base64Image;
  //         _isSigned = true;
  //       });
  //       // debugPrint("Signature saved successfully!");
  //     } else {
  //       throw Exception("Failed to convert signature to PNG data.");
  //     }
  //   } catch (e) {
  //     debugPrint("Error saving signature: $e");
  //   }
  // }

  Future<void> _handleSaveButtonPressed() async {
    if (!_isSigned) {
      debugPrint("No signature detected. Please draw a signature.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign before saving.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
        });
        debugPrint("Signature saved successfully!");
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

  Widget _digitalSignature() {
    String signatureUrl = signatureController.text.isNotEmpty
        ? '${AppConstants.baseUrl}/${signatureController.text}'
        : '';

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
                : (signatureUrl.isNotEmpty
                ? Image.network(
              signatureUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'Tap here to sign',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            )
                : Center(
              child: Text(
                'Tap here to sign',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            )),
          ),
        ),
      ),
    );
  }


  // Widget _digitalSignature() {
  //   String signatureUrl = signatureController.text.isNotEmpty
  //       ? '${AppConstants.baseUrl}/${signatureController.text}'
  //       : '';
  //
  //   return InkWell(
  //     splashColor: Colors.transparent,
  //     highlightColor: Colors.transparent,
  //     onTap: () {
  //       _showPopup();
  //     },
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //           width: double.infinity,
  //           height: 200,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey),
  //           ),
  //           child: _isSigned
  //               ? Image.memory(
  //                   _signatureData,
  //                   width: 500,
  //                   height: 500,
  //                   fit: BoxFit.contain,
  //                 )
  //               : (signatureUrl.isNotEmpty
  //                   ? Image.network(
  //                       signatureUrl,
  //                       width: double.infinity,
  //                       height: 200,
  //                       fit: BoxFit.contain,
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return Center(
  //                           child: Text(
  //                             'Tap here to sign',
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(fontSize: 20),
  //                           ),
  //                         );
  //                       },
  //                     )
  //                   : Center(
  //                       child: Text(
  //                         'Tap here to sign',
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(fontSize: 20),
  //                       ),
  //                     )),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _digitalSignature() {
  //   return InkWell(
  //     splashColor: Colors.transparent,
  //     highlightColor: Colors.transparent,
  //     onTap: () {
  //       _showPopup();
  //     },
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //           width: double.infinity,
  //           height: 200,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey),
  //           ),
  //           child: _isSigned
  //               ? Image.memory(
  //                   _signatureData,
  //                   width: 500,
  //                   height: 500,
  //                   fit: BoxFit.contain,
  //                 )
  //               : Center(
  //                   child: Text(
  //                     'Tap here to sign',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 20),
  //                   ),
  //                 ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

      final imageBytes = await selectedFile.readAsBytes();

      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        final resizedImage = img.copyResize(decodedImage, width: 300, height: 300);
        final compressedImage = img.encodeJpg(resizedImage, quality: 80);
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

  // Future<void> _pickImage(String type, ImageSource source) async {
  //   final XFile? photo = await _picker.pickImage(source: source);
  //   if (photo != null) {
  //     final File selectedFile = File(photo.path);
  //
  //     final compressedImage = await FlutterImageCompress.compressWithFile(
  //       selectedFile.path,
  //       minWidth: 300,
  //       minHeight: 300,
  //       quality: 80,
  //     );
  //
  //     if (compressedImage != null) {
  //       final base64String = base64Encode(compressedImage);
  //
  //       setState(() {
  //         if (type == 'front') {
  //           _aadhaarImageFront = base64String;
  //         } else if (type == 'back') {
  //           _aadhaarImageBack = base64String;
  //         }
  //       });
  //     }
  //   }
  // }

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

        final imageBytes = await croppedImageFile.readAsBytes();

        final decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          final resizedImage =
              img.copyResize(decodedImage, width: 300, height: 300);
          final compressedImage = img.encodeJpg(resizedImage, quality: 80);

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

  // Future<void> _pickAndCropImage(String type, ImageSource source) async {
  //   // Pick an image using the selected source
  //   final XFile? photo = await _picker.pickImage(source: source);
  //   if (photo != null) {
  //     // Crop the selected image
  //     CroppedFile? croppedFile = await ImageCropper().cropImage(
  //       sourcePath: photo.path,
  //       uiSettings: [
  //         IOSUiSettings(
  //           title: 'Edit Photo',
  //           aspectRatioPresets: [
  //             CropAspectRatioPreset.original,
  //             CropAspectRatioPreset.square,
  //           ],
  //         ),
  //       ],
  //     );
  //
  //     if (croppedFile != null) {
  //       final File croppedImageFile = File(croppedFile.path);
  //       final compressedImage = await FlutterImageCompress.compressWithFile(
  //         croppedImageFile.path,
  //         minWidth: 300, // Adjust resolution
  //         minHeight: 300,
  //         quality: 80,
  //       );
  //
  //       if (compressedImage != null) {
  //         final base64String = base64Encode(compressedImage);
  //
  //         setState(() {
  //           if (type == 'digital_photo') {
  //             _digitalPhoto = base64String;
  //           }
  //         });
  //       }
  //     }
  //   }
  // }

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
          aadhaar1DocController.text = '';
        } else if (type == 'back') {
          _aadhaarImageBack = '';
          aadhaar2DocController.text = '';
        } else if (type == 'digital_photo') {
          _digitalPhoto = '';
          imageController.text = '';
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
              Text('Aadhaar Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
              ),),
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
                          controller: aadharNumController,
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
                          controller: panController,
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
                  Text('Aadhaar Proof (Front/Back)',),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _selectImage('front'),
                            child: _aadhaarImageFront.isEmpty
                                ? (aadhaar1DocController.text.isNotEmpty
                                    ? Image.network(
                                        '${AppConstants.baseUrl}/${aadhaar1DocController.text}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        // loadingBuilder: (context, child, loadingProgress) {
                                        //   if (loadingProgress == null) {
                                        //     return child;
                                        //   }
                                        //   return Center(
                                        //     child: CircularProgressIndicator(
                                        //       value: loadingProgress.expectedTotalBytes != null
                                        //           ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        //           : null,
                                        //     ),
                                        //   );
                                        // },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.red,
                                          );
                                        },
                                      )
                                    : Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 50,
                                      ))
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
                                ? (aadhaar2DocController.text.isNotEmpty
                                    ? Image.network(
                                        '${AppConstants.baseUrl}/${aadhaar2DocController.text}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        // loadingBuilder: (context, child, loadingProgress) {
                                        //   if (loadingProgress == null) return child;
                                        //   return Center(
                                        //     child: CircularProgressIndicator(
                                        //       value: loadingProgress.expectedTotalBytes != null
                                        //           ? loadingProgress.cumulativeBytesLoaded /
                                        //           (loadingProgress.expectedTotalBytes ?? 1)
                                        //           : null,
                                        //     ),
                                        //   );
                                        // },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.red,
                                          );
                                        },
                                      )
                                    : Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 50,
                                      ))
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

  String selectedGenderCode = '1';
  String selectedMaritalCode = '';

  final Map<String, String> statusCodes = {
    'Married': '1',
    'Unmarried': '2',
    'Separated': '3',
    'Widow': '4',
  };

  void handleGenderSelected(int gender) {
    genderController.text = gender == 1 ? 'Male' : 'Female';
    selectedGenderCode = gender.toString();
    debugPrint('Selected Gender Code: $selectedGenderCode');
    debugPrint('Selected Gender Name: ${genderController.text}');
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
          title: Text('Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    iconWidget: Icon(Icons.person, color: Colors.blue),
                    controller: firstNameController,
                    labelText: 'Name (As Per Aadhaar)',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      firstName = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: lastNameController,
                    iconWidget: Icon(Icons.person, color: Colors.blue),
                    // icon: Icons.person,
                    labelText: 'Last Name',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      lastName = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: fatherNameController,
                    iconWidget: Icon(Icons.person, color: Colors.blue),
                    // icon: Icons.person,
                    labelText: "Father's Name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      fatherName = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: motherNameController,
                    iconWidget: Icon(Icons.person, color: Colors.blue),
                    // icon: Icons.person,
                    labelText: "Mother's Name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      motherName = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: spouseNameController,
                    iconWidget: Icon(Icons.person, color: Colors.blue),
                    // icon: Icons.person,
                    labelText: "Spouse's Name",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    onChanged: (value) {
                      spouseName = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: mobileNoController,
                    iconWidget: Icon(Icons.call, color: Colors.blue),
                    maxLength: 10,
                    labelText: "Mobile No",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      mobNo = value!;
                    },
                  ),



                  // CustomTextFormField(
                  //   iconWidget: Icon(Icons.calendar_month, color: Colors.blue),
                  //   // icon: Icons.calendar_month,
                  //   labelText: 'DOB',
                  //   isDatePicker: true,
                  //   controller: dobController,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       if (value != null && value.isNotEmpty) {
                  //         try {
                  //           final inputFormat = DateFormat('dd-MM-yyyy');
                  //           final parsedDate = inputFormat.parse(value);
                  //
                  //           final outputFormat = DateFormat('yyyy-MM-dd');
                  //           dob = outputFormat.format(parsedDate);
                  //
                  //           dobController.text = value;
                  //         } catch (e) {
                  //           debugPrint('Error parsing date: $e');
                  //         }
                  //       }
                  //     });
                  //   },
                  // ),

                  CustomTextFormField(
                    iconWidget: Icon(Icons.calendar_month, color: Colors.blue),
                    labelText: 'DOB',
                    isDatePicker: true,
                    controller: dobController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          dob = formatDate(value, inputFormat: 'dd-MM-yyyy', outputFormat: 'yyyy-MM-dd'); // Format for API
                          dobController.text = value; // Keep the display format
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
                  // GenderRadioButtons(
                  //   initialGender: genderController.text,
                  //   onGenderSelected: handleGenderSelected,
                  // ),

                    // GenderRadioButtons(onGenderSelected: handleGenderSelected, initialGender: '',),
                  GenderRadioButtons(
                    onGenderSelected: handleGenderSelected,
                    initialGender: selectedGenderCode,
                  ),

                  // GenderRadioButtons(
                  //   onGenderSelected: handleGenderSelected,
                  //   initialGender: '', // Pass initial gender (if any, e.g., 'Male' or 'Female')
                  // ),

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
          title: Text('Personal Documents',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
          ),
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
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100,
                          child: ClipOval(
                            child: _digitalPhoto.isEmpty
                                ? (imageController.text.isNotEmpty
                                    ? Image.network(
                                        '${AppConstants.baseUrl}/${imageController.text}',
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/user_camera.png',
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: 200,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/user_camera.png',
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      ))
                                : Image.memory(
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
                    child: _digitalSignature()),
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
                signatureController.text = '';
                _signaturePadKey.currentState?.clear();
                // _isSigned = false;
                // _signatureData = Uint8List(0);

                _isSigned = false;
                _signatureData = Uint8List(0); // Reset the signature data to an empty value
                _base64Signature = ''; // Clear the base64 signature

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
          title: Text('Deployment Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
          ),
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
  DesignationListViewModel designationListViewModel = DesignationListViewModel();
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
