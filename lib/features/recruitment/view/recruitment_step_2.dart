import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/core/theme/app_pallete.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/update_recruitment02_model.dart';
import 'package:vigo_smart_app/features/recruitment/view%20model/update_recruitment02_view_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_3.dart';
import 'package:vigo_smart_app/features/recruitment/widget/custom_text_form_field.dart';
import '../../../helper/toast_helper.dart';
import '../view model/bank_list_view_model.dart';
import '../view model/get_city_view_model.dart';
import '../view model/get_state_view_model.dart';
import 'package:image/image.dart' as img;
import '../view model/pre_recruitment_by_id_view_model.dart';

class RecruitmentStep2 extends StatefulWidget {
  final dynamic userId;
  final dynamic recruitedUserId;

  const RecruitmentStep2(
      {super.key, required this.userId, this.recruitedUserId});

  @override
  State<RecruitmentStep2> createState() => _RecruitmentStep2State();
}

class _RecruitmentStep2State extends State<RecruitmentStep2> {
  SessionManager sessionManager = SessionManager();
  String? recruitedUserId;
  bool _expandAll = true;
  bool isLocalStateSelected = false;
  bool isLocalCitySelected = false;

  String currentAddress = '';
  String pinCode = '';
  String cPoliceStation = '';
  String cPostOffice = '';
  String permanentAddress = '';
  String pPIN = '';
  String pPoliceStation = '';
  String pPostOffice = '';
  String bankName = '';
  String selectedBankName = '';
  String accountHolderName = '';
  String accountNo = '';
  String ifscCode = '';
  String responsibleEmail1 = '';
  String responsiblePerson1 = '';
  String responsibleAdd1 = '';
  String responsibleReference1 = '';

  //local address
  final TextEditingController localLine1AddressController = TextEditingController();
  final TextEditingController localPincodeController = TextEditingController();
  final TextEditingController localStateController = TextEditingController();
  final TextEditingController localCityController = TextEditingController();
  final TextEditingController localPoliceStationController = TextEditingController();
  final TextEditingController localPostOfficeController = TextEditingController();

  //permanent address
  final TextEditingController permanentLine1AddressController = TextEditingController();
  final TextEditingController permanentPincodeController = TextEditingController();
  final TextEditingController permanentPoliceStationController = TextEditingController();
  final TextEditingController permanentPostOfficeController = TextEditingController();
  final TextEditingController permanentStateController = TextEditingController();
  final TextEditingController permanentCityController = TextEditingController();

  //user id
  TextEditingController userIdController = TextEditingController();
  //bank details
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankIdController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNumController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController bankDocsController = TextEditingController();

  //contact details
  TextEditingController responsibleEmail1Controller = TextEditingController();
  TextEditingController responsiblePerson1Controller = TextEditingController();
  TextEditingController responsibleAdd1Controller = TextEditingController();
  TextEditingController responsibleReference1Controller = TextEditingController();

  // Checkbox state
  bool isPermanentSameAsLocal = false;

  // Tracks whether the checkbox was previously checked
  bool wasCheckboxPreviouslyChecked = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    if (widget.recruitedUserId != null) {
      fetchPreRecruitmentByIdData().then((_) {
        fetchCityData().then((_) {
          fetchStateData().then((_) {
            fetchBankListData().then((_) {
              setState(() {
                localSelectedStateId = preRecruitmentByIdData[0]["currentStateId"];
                Map<String, String> stateMap = {
                  for (var state in stateListData) state['value']: state['text'],
                };
                localSelectedStateText = stateMap[localSelectedStateId] ?? '';
                localStateController.text = stateMap[localSelectedStateId] ?? '';

                localSelectedCityId = preRecruitmentByIdData[0]["currentCityid"];
                Map<String, String> cityMap = {
                  for (var city in cityListData) city['value']: city['text'],
                };
                localSelectedCityText = cityMap[localSelectedCityId] ?? '';
                localCityController.text = cityMap[localSelectedCityId] ?? '';

                // Permanent state
                permanentSelectedStateId = preRecruitmentByIdData[0]["permanentStateId"];
                Map<String, String> permanentStateMap = {
                  for (var permanentState in stateListData) permanentState['value']: permanentState['text'],
                };
                permanentSelectedStateText = permanentStateMap[permanentSelectedStateId] ?? '';
                permanentStateController.text = permanentStateMap[permanentSelectedStateId] ?? '';

                // Permanent city
                permanentSelectedCityId = preRecruitmentByIdData[0]["permanentCityId"];
                Map<String, String> permanentCityMap = {
                  for (var permanentCity in cityListData) permanentCity['value']: permanentCity['text'],
                };
                permanentSelectedCityText = permanentCityMap[permanentSelectedCityId] ?? '';
                permanentCityController.text = permanentCityMap[permanentSelectedCityId] ?? '';
              });
            });
          });
        });
      });
    } else if (widget.userId != null) {
      fetchStateData();
      fetchCityData();
      fetchBankListData();
    }
  }

  //PreRecruitment By ID
  PreRecruitmentByIdViewModel preRecruitmentByIdViewModel = PreRecruitmentByIdViewModel();
  List<Map<String, dynamic>> preRecruitmentByIdData = [];

  String localSelectedStateText = '';
  String localSelectedCityText = '';
  String permanentSelectedStateText = '';
  String permanentSelectedCityText = '';

  Future<void> fetchPreRecruitmentByIdData() async {
    String? token = await preRecruitmentByIdViewModel.sessionManager.getToken();

    if (token != null) {
      await preRecruitmentByIdViewModel.fetchPreRecruitmentByIdList(
          token, widget.recruitedUserId);

      if (preRecruitmentByIdViewModel.getPreRecruitmentByIdList != null) {
        setState(() {
          preRecruitmentByIdData =
              preRecruitmentByIdViewModel.getPreRecruitmentByIdList!
                  .map((entry) => {
                        "userId": entry.userId,
                        "currentAddress": entry.currentAddress,
                        "currentPin": entry.currentPin,
                        "currentStateId": entry.currentStateId,
                        "currentCityid": entry.currentCityid,
                        "currentPoliceStation": entry.currentPoliceStation,
                        "currentPostOffice": entry.currentPostOffice,
                        "permanentAddress": entry.permanentAddress,
                        "permanentPin": entry.permanentPin,
                        "permanentStateId": entry.permanentStateId,
                        "permanentCityId": entry.permanentCityId,
                        "permanentPoliceStation": entry.permanentPoliceStation,
                        "permanentPostOffice": entry.permanentPostOffice,
                        "bankName": entry.bankName,
                        "bankId": entry.bankId,
                        "accountHolderName": entry.accountHolderName,
                        "accntNo": entry.accntNo,
                        "ifscCode": entry.ifscCode,
                        "bankDocs": entry.bankDocs,
                        "emergencyEmail1": entry.emergencyEmail1,
                        "emergencyName1": entry.emergencyName1,
                        "emergencyContactDetails1": entry.emergencyContactDetails1,
                        "emergencyContactReferenceDetails1": entry.emergencyContactReferenceDetails1,
                      })
                  .toList();
          if (preRecruitmentByIdData.isNotEmpty) {
            userIdController.text = preRecruitmentByIdData[0]["userId"] ?? "";
            recruitedUserId = preRecruitmentByIdData[0]["userId"] ?? "";

            //local address
            currentAddress = preRecruitmentByIdData[0]["currentAddress"] ?? "";
            localLine1AddressController.text = currentAddress;
            pinCode = preRecruitmentByIdData[0]["currentPin"] ?? "";
            localPincodeController.text = pinCode;

            cPoliceStation = preRecruitmentByIdData[0]["currentPoliceStation"];
            localPoliceStationController.text = cPoliceStation;
            cPostOffice = preRecruitmentByIdData[0]["currentPostOffice"];
            localPostOfficeController.text = cPostOffice;

            //permanent address
            permanentAddress = preRecruitmentByIdData[0]["permanentAddress"] ?? "";
            permanentLine1AddressController.text = permanentAddress;

            pPIN = preRecruitmentByIdData[0]["permanentPin"] ?? "";
            permanentPincodeController.text = pPIN;

            pPoliceStation = preRecruitmentByIdData[0]["permanentPoliceStation"];
            permanentPoliceStationController.text = pPoliceStation;
            pPostOffice = preRecruitmentByIdData[0]["permanentPostOffice"];
            permanentPostOfficeController.text = pPostOffice;

            //contact details
            responsibleEmail1 = preRecruitmentByIdData[0]["emergencyEmail1"];
            responsibleEmail1Controller.text = responsibleEmail1;
            responsiblePerson1 = preRecruitmentByIdData[0]["emergencyName1"];
            responsiblePerson1Controller.text = responsiblePerson1;
            responsibleAdd1 = preRecruitmentByIdData[0]["emergencyContactDetails1"];
            responsibleAdd1Controller.text = responsibleAdd1;
            responsibleReference1 = preRecruitmentByIdData[0]["emergencyContactReferenceDetails1"];
            responsibleReference1Controller.text = responsibleReference1;

            //bank
            selectedBankName = preRecruitmentByIdData[0]["bankName"] ?? "";
            bankNameController.text = selectedBankName;

            selectedBankId = preRecruitmentByIdData[0]["bankId"] ?? "";
            bankIdController.text = selectedBankId;

            accountHolderName = preRecruitmentByIdData[0]["accountHolderName"];
            accHolderNameController.text = accountHolderName;
            accountNo = preRecruitmentByIdData[0]["accntNo"];
            accNumController.text = accountNo;
            ifscCode = preRecruitmentByIdData[0]["ifscCode"];
            ifscCodeController.text = ifscCode;
            bankDocsController.text = preRecruitmentByIdData[0]["bankDocs"] ?? "";
          }
        });
      }
    }
  }

  String getCityTextFromId(String cityId) {
    var city = filterCityListData.firstWhere(
      (city) => city['value'] == cityId,
      orElse: () => {'text': 'Unknown City'},
    );
    return city['text'] ?? 'Unknown City';
  }

  String getStateTextFromId(String stateId) {
    var state = filterStateListData.firstWhere(
      (state) => state['value'] == stateId,
      orElse: () => {'text': 'Unknown State'},
    );
    return state['text'] ?? 'Unknown State';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 2'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _expandAll = !_expandAll;
              });
            },
            icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _localAddress(),
              _permanentAddress(),
              _bankDetails(),
              _contactDetails(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          try {
                            final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                            final validations = [
                              {responsibleEmail1.isNotEmpty && !emailRegex.hasMatch(responsibleEmail1Controller.text):
                                'Please enter a valid email',
                              },
                            ];

                            for (var validation in validations) {
                              if (validation.keys.first) {
                                ToastHelper.showToast(message: validation.values.first, context: context);
                                return;
                              }
                            }

                            String? token = await sessionManager.getToken();
                            UpdateRecruitment02ViewModel updateRecruitment02ViewModel = UpdateRecruitment02ViewModel();
                    
                            Map<String, dynamic> response = await updateRecruitment02ViewModel.updateRecruitment02(
                              token!,
                              UpdateRecruitment02Model(
                                userId: widget.userId ?? widget.recruitedUserId,
                                currentAddress: currentAddress,
                                CPin: pinCode,
                                CState: localSelectedStateId,
                                CCity: localSelectedCityId,
                                CPoliceStation: cPoliceStation,
                                CPostOffice: cPostOffice,
                                PermanentAddress: permanentAddress,
                                PPIN: pPIN,
                                PState: permanentSelectedStateId,
                                Pcity: permanentSelectedCityId,
                                PPoliceStation: pPoliceStation,
                                PPostOffice: pPostOffice,
                                bankId: selectedBankId,
                                bank_name: selectedBank,
                                accountHolderName: accountHolderName,
                                account_no: accountNo,
                                IFSC_code: ifscCode,
                                bankProofImage: _passBookImage,
                                responsible_email1: responsibleEmail1,
                                responsible_person1: responsiblePerson1,
                                responsible_add1: responsibleAdd1,
                                responsible_Reference1: responsibleReference1,
                              ),
                            );
                    
                            if (response['code'] == 200) {
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
                                        builder: (context) => RecruitmentStep3(
                                          userId: widget.userId,
                                          recruitedUserId: widget.recruitedUserId,
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              QuickAlert.show(
                                barrierDismissible: false,
                                confirmBtnText: 'Retry',
                                context: context,
                                type: QuickAlertType.error,
                                text:
                                    '${response['message'] ?? 'Something went wrong'}',
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'An error occurred. Please try again later.')),
                            );
                          }
                        },
                        child: FittedBox(
                          child: Text(
                            'Submit and Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecruitmentStep3(
                                userId: widget.userId,
                                recruitedUserId: widget.recruitedUserId,
                              ),
                            ),
                          );
                        },
                        child: FittedBox(
                          child: Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _localAddress() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text(
            'Local Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            CustomTextFormField(
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              controller: localLine1AddressController,
              labelText: 'Line 1',
              onChanged: (value) {
                currentAddress = value!;
              },
            ),
            CustomTextFormField(
              maxLength: 6,
              keyboardType: TextInputType.number,
              controller: localPincodeController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Pincode',
              onChanged: (value) {
                pinCode = value!;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Pallete.location.icon!, size: 30, color: Pallete.green),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: localStateController,
                      readOnly: true,
                      onTap: () => showStateDialog('local'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        labelText: 'State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Pallete.location.icon!, size: 30, color: Pallete.green),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: localCityController,
                      readOnly: true,
                      onTap: () => showCityDialog('local'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        labelText: 'District',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomTextFormField(
              controller: localPoliceStationController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Police Station',
              onChanged: (value) {
                cPoliceStation = value!;
              },
            ),
            CustomTextFormField(
              controller: localPostOfficeController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Post Office',
              onChanged: (value) {
                cPostOffice = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isChecked = false;

  Widget _permanentAddress() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text('Permanent Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            Row(
              children: [
                Checkbox(
                  value: isPermanentSameAsLocal,
                  onChanged: (value) {
                    setState(() {
                      isPermanentSameAsLocal = value!;
                      if (isPermanentSameAsLocal) {
                        if (!wasCheckboxPreviouslyChecked) {
                          permanentAddress = currentAddress;
                          permanentLine1AddressController.text = localLine1AddressController.text;
                          pPIN = pinCode;
                          permanentPincodeController.text = localPincodeController.text;
                          pPoliceStation = cPoliceStation;
                          permanentPoliceStationController.text = localPoliceStationController.text;
                          pPostOffice = cPostOffice;
                          permanentPostOfficeController.text = localPostOfficeController.text;
                          permanentSelectedStateId = localSelectedStateId;
                          permanentSelectedCityId = localSelectedCityId;
                          permanentStateController.text = localStateController.text;
                          permanentCityController.text = localCityController.text;
                        }
                      }
                      wasCheckboxPreviouslyChecked = isPermanentSameAsLocal;
                    });
                  },
                ),
                Text('SAME AS ABOVE (Local Address)'),
              ],
            ),
            CustomTextFormField(
              controller: permanentLine1AddressController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Line 1',
              enabled: !isPermanentSameAsLocal,
              onChanged: (value) {
                permanentAddress = value!;
              },
            ),
            CustomTextFormField(
              controller: permanentPincodeController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Pincode',
              maxLength: 6,
              keyboardType: TextInputType.number,
              enabled: !isPermanentSameAsLocal,
              onChanged: (value) {
                pPIN = value!;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Pallete.location.icon!, size: 30, color: Pallete.green),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: permanentStateController,
                      enabled: !isPermanentSameAsLocal,
                      readOnly: true,
                      onTap: () => showStateDialog('permanent'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: 'State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Pallete.location.icon!, size: 30, color: Pallete.green),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextFormField(
                      controller: permanentCityController,
                      enabled: !isPermanentSameAsLocal,
                      readOnly: true,
                      onTap: () => showCityDialog('permanent'),
                      // onTap: () => {},
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: 'District',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomTextFormField(
              controller: permanentPoliceStationController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Police Station',
              enabled: !isPermanentSameAsLocal,
              onChanged: (value) {
                pPoliceStation = value!;
              },
            ),
            CustomTextFormField(
              controller: permanentPostOfficeController,
              iconWidget: Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Post Office',
              enabled: !isPermanentSameAsLocal,
              onChanged: (value) {
                pPostOffice = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankDetails() {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text('Bank Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 30,
                    color: Colors.blueGrey,
                  ),
                  Expanded(child: _selectBank()),
                ],
              ),
            ),
            CustomTextFormField(
              controller: accHolderNameController,
              iconWidget: Icon(
                Icons.person,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Account holder name',
              onChanged: (value) {
                accountHolderName = value!;
              },
            ),
            CustomTextFormField(
              controller: accNumController,
              iconWidget: Icon(
                Icons.credit_card,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Account no',
              onChanged: (value) {
                accountNo = value!;
              },
            ),
            CustomTextFormField(
              controller: ifscCodeController,
              iconWidget: Icon(
                Icons.credit_card,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'IFSC Code',
              onChanged: (value) {
                ifscCode = value!;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Click to Upload PassBook Image',
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectImage(),
                      child: _passBookImage.isEmpty
                          ? (bankDocsController.text.isNotEmpty
                              ? Image.network(
                                  '${AppConstants.baseUrl}/${bankDocsController.text}',
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                )
                              : Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 50,
                                ))
                          : Image.memory(
                              base64Decode(_passBookImage),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => _deleteImage(),
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
    );
  }

  Widget _contactDetails() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(_expandAll),
          initiallyExpanded: _expandAll,
          title: Text(
            'Contact Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            CustomTextFormField(
              controller: responsibleEmail1Controller,
              iconWidget: Icon(
                Icons.email_sharp,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Email id',
              onChanged: (value) {
                responsibleEmail1 = value!;
              },
            ),
            CustomTextFormField(
              controller: responsiblePerson1Controller,
              iconWidget: Icon(
                Icons.person,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Emergency Contact Name',
              onChanged: (value) {
                responsiblePerson1 = value!;
              },
            ),
            CustomTextFormField(
              controller: responsibleAdd1Controller,
              iconWidget: Icon(
                Icons.add_alert,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Emergency Contact Number',
              maxLength: 10,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                responsibleAdd1 = value!;
              },
            ),
            CustomTextFormField(
              controller: responsibleReference1Controller,
              iconWidget: Icon(
                Icons.person,
                color: Colors.green,
                size: 30,
              ),
              labelText: 'Reference within Company/Org',
              onChanged: (value) {
                responsibleReference1 = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  String _passBookImage = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
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
                  await _pickImage(ImageSource.camera);
                }),
            ListTile(
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (photo != null) {
      final File selectedFile = File(photo.path);

      final imageBytes = await selectedFile.readAsBytes();

      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        final resizedImage =
            img.copyResize(decodedImage, width: 1920, height: 1080);
        final compressedImage = img.encodeJpg(resizedImage, quality: 80);

        final base64String = base64Encode(compressedImage);

        setState(() {
          _passBookImage = base64String;
        });
      }
    }
  }

  void _deleteImage() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete the image?',
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
        _passBookImage = '';
        bankDocsController.text = '';
      });
    }
  }

  // Get Assign Bank List
  BankListViewModel bankListViewModel = BankListViewModel();
  List<Map<String, dynamic>> bankListData = [];
  List<Map<String, dynamic>> filterBankListData = [];
  String selectedBank = '';
  String selectedBankId = '';

  Future<void> fetchBankListData() async {
    String? token = await bankListViewModel.sessionManager.getToken();
    if (token != null) {
      await bankListViewModel.fetchAssignBankList(token);

      setState(() {
        if (bankListViewModel.assignBankList != null) {
          bankListData = bankListViewModel.assignBankList!
              .map((entry) => {
                    "bankId": entry.bankId,
                    "shortCode": entry.shortCode,
                    "bankName": entry.bankName,
                  })
              .toList();
        }
      });
      setState(() {
        filterBankListData = bankListData;
      });
    }
  }

  Widget _selectBank() {
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
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                        maxWidth: 500,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select Bank',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                setDialogState(() {
                                  filterBankListData = bankListData
                                      .where((bank) =>
                                          bank['bankName']
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
                            child: filterBankListData.isNotEmpty
                                ? ListView.separated(
                                    itemCount: filterBankListData.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey.shade900,
                                      thickness: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index >= filterBankListData.length) {
                                        return SizedBox.shrink();
                                      }
                                      final bank = filterBankListData[index];
                                      return ListTile(
                                        title: Text(bank['bankName'] ?? ''),
                                        onTap: () {
                                          setState(() {
                                            selectedBank =
                                                bank['bankName'] ?? '';
                                            selectedBankId =
                                                bank['bankId'] ?? '';
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
              selectedBank.isNotEmpty
                  ? selectedBank
                  : (bankNameController.text.isNotEmpty
                      ? bankNameController.text
                      : 'Select Bank'),
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

  // Get State List
  GetStateViewModel getStateViewModel = GetStateViewModel();
  List<Map<String, dynamic>> stateListData = [];
  List<Map<String, dynamic>> filterStateListData = [];

  String selectedState = '';
  String localSelectedStateId = '';
  String permanentSelectedStateId = '';

  Future<void> fetchStateData() async {
    String? token = await getStateViewModel.sessionManager.getToken();

    if (token != null) {
      await getStateViewModel.fetchStateList(token);

      if (getStateViewModel.stateList != null) {
        setState(() {
          stateListData = getStateViewModel.stateList!
              .map((entry) => {
                    'value': entry.value,
                    'text': entry.text,
                    'parentId': entry.parentId,
                  })
              .toList();
        });
      }
    }
  }

  String selectedStatePrefixValue = '';

  Future<void> showStateDialog(String fieldType) async {
    isLocalStateSelected = fieldType == 'local';

    // Initialize the filtered list with the full state list at the start
    filterStateListData = List.from(stateListData);

    return showDialog(
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
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: 500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select State',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setDialogState(() {
                        filterStateListData = stateListData
                            .where((state) =>
                        state['text']?.toLowerCase().contains(value.toLowerCase()) ?? false)
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
                  child: ListView.builder(
                    itemCount: filterStateListData.length,
                    itemBuilder: (context, index) {
                      final state = filterStateListData[index];
                      return ListTile(
                        title: Text(state['text']),
                        onTap: () {
                          String selectedStateValue = state['value'];
                          Navigator.pop(context);
                          String selectedStatePrefix = selectedStateValue;
                          // String selectedStatePrefix = selectedStateValue.split('-').first.trim();
                          setState(() {
                            if (isLocalStateSelected) {
                              localStateController.text = state['text'];
                              localSelectedStateId = state['value'];
                              localCityController.text = '';
                              localSelectedCityId = '';
                            } else {
                              permanentStateController.text = state['text'];
                              permanentSelectedStateId = state['value'];
                              permanentCityController.text = '';
                              permanentSelectedCityId = '';
                            }
                            // selectedState = state['text'] ?? localSelectedStateText;
                            // selectedStatePrefixValue = selectedStatePrefix;
                            // debugPrint('${state['text']}');

                            selectedState = state['value'] ?? localSelectedStateText;
                            selectedStatePrefixValue = selectedStatePrefix;
                            debugPrint('${state['value']}');
                          });
                        },
                      );
                    },
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
  }

  //Get City List
  GetCityViewModel getCityViewModel = GetCityViewModel();
  List<Map<String, dynamic>> cityListData = [];
  List<Map<String, dynamic>> filterCityListData = [];

  String selectedCity = '';
  String localSelectedCityId = '';
  String permanentSelectedCityId = '';

  Future<void> fetchCityData() async {
    String? token = await getCityViewModel.sessionManager.getToken();

    if (token != null) {
      await getCityViewModel.fetchCityList(token);

      if (getCityViewModel.cityList != null) {
        setState(() {
          cityListData = getCityViewModel.cityList!
              .map((entry) => {
                    'value': entry.value,
                    'text': entry.text,
                    'parentId': entry.parentId,
                  })
              .toList();
        });
      }
    }
  }

  Future<void> showCityDialog(String fieldType) async {
    isLocalCitySelected = fieldType == 'local';

    // selectedStatePrefixValue = localSelectedStateId;

    // Assign selectedStatePrefixValue based on fieldType
    selectedStatePrefixValue = isLocalCitySelected
        ? localSelectedStateId
        : permanentSelectedStateId;

    // Filter cities based on selected state initially
    List<Map<String, dynamic>> filteredCities = cityListData
        .where((city) => city['parentId']?.startsWith(selectedStatePrefixValue) ?? false)
        .toList();

    return showDialog(
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
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: 500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select District',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setDialogState(() {
                        // Filter the cities dynamically based on search input
                        filteredCities = cityListData
                            .where((city) =>
                        (city['parentId']?.startsWith(selectedStatePrefixValue) ?? false) &&
                            (city['text']?.toLowerCase().contains(value.toLowerCase()) ?? false))
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
                  child: ListView.builder(
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = filteredCities[index];

                      return ListTile(
                        title: Text(city['text'] ?? ''),
                        onTap: () {
                          setState(() {
                            if (isLocalCitySelected) {
                              localCityController.text = city['text'] ?? '';
                              localSelectedCityId = city['value'] ?? '';
                            } else {
                              permanentCityController.text = city['text'] ?? '';
                              permanentSelectedCityId = city['value'] ?? '';
                            }
                          });
                          debugPrint("Selected City: ${city['text']}");
                          Navigator.pop(context);
                        },
                      );
                    },
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
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    localLine1AddressController.dispose();
    localPincodeController.dispose();
    localPoliceStationController.dispose();
    localPostOfficeController.dispose();
    localStateController.dispose();
    localCityController.dispose();

    permanentLine1AddressController.dispose();
    permanentPincodeController.dispose();
    permanentPoliceStationController.dispose();
    permanentPostOfficeController.dispose();
    permanentStateController.dispose();
    permanentCityController.dispose();
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
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
