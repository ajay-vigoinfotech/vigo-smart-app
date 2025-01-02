import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/core/theme/app_pallete.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/update_recruitment_model.dart';
import 'package:vigo_smart_app/features/recruitment/view%20model/update_recruitment_view_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_1.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_3.dart';
import 'package:vigo_smart_app/features/recruitment/widget/custom_text_form_field.dart';
import '../view model/bank_list_view_model.dart';
import '../view model/get_city_view_model.dart';
import '../view model/get_state_view_model.dart';

class RecruitmentStep2 extends StatefulWidget {
  final dynamic userId;

  const RecruitmentStep2({super.key,
    required this.userId});

  @override
  State<RecruitmentStep2> createState() => _RecruitmentStep2State();
}

class _RecruitmentStep2State extends State<RecruitmentStep2> {
  SessionManager sessionManager = SessionManager();
  final bool _expandAll = true;
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
  String accountHolderName = '';
  String accountNo = '';
  String ifscCode = '';
  String responsibleEmail1 = '';
  String responsiblePerson1 = '';
  String responsibleAdd1 = '';
  String responsibleReference1 = '';

  //local address
  final TextEditingController localLine1AddressController =
      TextEditingController();
  final TextEditingController localPincodeController = TextEditingController();
  final TextEditingController localPoliceStationController =
      TextEditingController();
  final TextEditingController localPostOfficeController =
      TextEditingController();
  final TextEditingController localStateController = TextEditingController();
  final TextEditingController localCityController = TextEditingController();

  //permanent address
  final TextEditingController permanentLine1AddressController =
      TextEditingController();
  final TextEditingController permanentPincodeController =
      TextEditingController();
  final TextEditingController permanentPoliceStationController =
      TextEditingController();
  final TextEditingController permanentPostOfficeController =
      TextEditingController();
  final TextEditingController permanentStateController =
      TextEditingController();
  final TextEditingController permanentCityController = TextEditingController();

  // Checkbox state
  bool isPermanentSameAsLocal = false;

  // Tracks whether the checkbox was previously checked
  bool wasCheckboxPreviouslyChecked = false;

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

  @override
  void initState() {
    fetchStateData();
    fetchCityData();
    fetchBankListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 2'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecruitmentStep1()));
              // setState(() {
              //   _expandAll = !_expandAll;
              // });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          String? token = await sessionManager.getToken();
                          UpdateRecruitmentViewModel updateRecruitmentViewModel = UpdateRecruitmentViewModel();

                          Map<String,dynamic> response = await updateRecruitmentViewModel.updateRecruitment(token!,
                              UpdateRecruitmentModel(
                                  userId: widget.userId,
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
                            Navigator.of(context).pop();
                            QuickAlert.show(
                              confirmBtnText: 'Ok',
                              context: context,
                              type: QuickAlertType.success,
                              text: '${response['status']}',
                              onConfirmBtnTap: () {
                                Navigator.pushReplacement(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) => RecruitmentStep3()),
                                );
                              },
                            );
                          } else {

                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error::: $error')),
                          );
                        }
                      },
                      child: Text('Submit and Next')),
                  ElevatedButton(onPressed: () {}, child: Text('Next')),
                ],
              ),
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
              controller: localLine1AddressController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
              labelText: 'Line 1',
              onChanged: (value) {
                currentAddress = value!;
              },
            ),
            CustomTextFormField(
              controller: localPincodeController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
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
                      controller: localCityController,
                      readOnly: true,
                      onTap: () => showCityDialog('local'),
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
              controller: localPoliceStationController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
              labelText: 'Police Station',
              onChanged: (value) {
                cPoliceStation = value!;
              },
            ),
            CustomTextFormField(
              controller: localPostOfficeController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
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

  // final TextEditingController stateController = TextEditingController();

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
          title: Text('Permanent Address'),
          children: [
            Row(
              children: [
                Checkbox(
                  value: isPermanentSameAsLocal,
                  onChanged: (value) {
                    setState(() {
                      isPermanentSameAsLocal = value!;

                      if (isPermanentSameAsLocal) {
                        // Update permanent address if the checkbox was just checked
                        if (!wasCheckboxPreviouslyChecked) {
                          permanentLine1AddressController.text =
                              localLine1AddressController.text;
                          permanentPincodeController.text =
                              localPincodeController.text;
                          permanentPoliceStationController.text =
                              localPoliceStationController.text;
                          permanentPostOfficeController.text =
                              localPostOfficeController.text;
                          permanentStateController.text =
                              localStateController.text;
                          permanentCityController.text =
                              localCityController.text;
                        }
                      }
                      // Track the checkboxes previous state
                      wasCheckboxPreviouslyChecked = isPermanentSameAsLocal;
                    });
                  },
                ),
                Text('SAME AS ABOVE (Local Address)'),
              ],
            ),
            CustomTextFormField(
              controller: permanentLine1AddressController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
              labelText: 'Line 1',
              enabled: !isPermanentSameAsLocal,
              onChanged: (value) {
                permanentAddress = value!;
              },
            ),
            CustomTextFormField(
              controller: permanentPincodeController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
              labelText: 'Pincode',
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
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
              labelText: 'Police Station',
              enabled: !isPermanentSameAsLocal,
              onChanged: (value) {
                pPoliceStation = value!;
              },
            ),
            CustomTextFormField(
              controller: permanentPostOfficeController,
              iconColor: Pallete.green,
              icon: Pallete.location.icon!,
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
          title: Text('Bank Details'),
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
              // controller: permanentLine1AddressController,
              iconColor: Pallete.teal,
              icon: Pallete.user.icon!,
              labelText: 'Account holder name',
              onChanged: (value) {
                accountHolderName = value!;
              },
            ),
            CustomTextFormField(
              // controller: permanentLine1AddressController,
              iconColor: Pallete.green,
              icon: Pallete.card.icon!,
              labelText: 'Account no',
              onChanged: (value) {
                accountNo = value!;
              },
            ),
            CustomTextFormField(
              // controller: permanentLine1AddressController,
              iconColor: Pallete.green,
              icon: Pallete.card.icon!,
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
                          ? Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                            )
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
              controller: localLine1AddressController,
              iconColor: Pallete.red,
              icon: Pallete.email.icon!,
              labelText: 'Email id',
              onChanged: (value) {
                responsibleEmail1 = value!;
              },
            ),
            CustomTextFormField(
              // controller: localPoliceStationController,
              iconColor: Pallete.green,
              icon: Pallete.user.icon!,
              labelText: 'Emergency Contact Name',
              onChanged: (value) {
                responsiblePerson1 = value!;
              },
            ),
            CustomTextFormField(
              // controller: localPostOfficeController,
              iconColor: Pallete.green,
              icon: Pallete.alert.icon!,
              labelText: 'Emergency Contact Number',
              onChanged: (value) {
                responsibleAdd1 = value!;
              },
            ),
            CustomTextFormField(
              // controller: localPincodeController,
              iconColor: Pallete.green,
              icon: Pallete.user.icon!,
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
                                            selectedBank =bank['bankName'] ?? '';
                                            selectedBankId = bank['bankId'] ?? '';
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
              selectedBank.isEmpty ? 'Select Bank' : selectedBank,
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
      setState(() {
        filterStateListData = stateListData;
      });
    }
  }

  void showStateDialog(String fieldType) async {
    isLocalStateSelected = fieldType == 'local';
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
                                state['text']
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
                  child: filterStateListData.isNotEmpty
                      ? ListView.separated(
                          itemCount: filterStateListData.length,
                          separatorBuilder: (context, index) => Divider(
                              color: Colors.grey.shade900, thickness: 1),
                          itemBuilder: (context, index) {
                            if (index >= filterStateListData.length) {
                              return SizedBox.shrink();
                            }
                            final state = filterStateListData[index];
                            return ListTile(
                              title: Text(state['text'] ?? ''),
                              onTap: () {
                                setState(() {
                                  selectedState = state['text'] ?? '';
                                  if (isLocalStateSelected) {
                                    localStateController.text = selectedState;
                                    localSelectedStateId = state['value'];
                                  } else {
                                    permanentStateController.text = selectedState;
                                    permanentSelectedStateId = state['value'];
                                  }
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text('No records found',
                              style: TextStyle(fontSize: 16)),
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
      setState(() {
        filterCityListData = cityListData;
      });
    }
  }

  void showCityDialog(String fieldType) async {
    isLocalCitySelected = fieldType == 'local';
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
                        filterCityListData = cityListData
                            .where((city) =>
                                city['text']
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
                  child: filterCityListData.isNotEmpty
                      ? ListView.separated(
                          itemCount: filterCityListData.length,
                          separatorBuilder: (context, index) => Divider(
                              color: Colors.grey.shade900, thickness: 1),
                          itemBuilder: (context, index) {
                            if (index >= filterCityListData.length) {
                              return SizedBox.shrink();
                            }
                            final city = filterCityListData[index];
                            return ListTile(
                              title: Text(city['text'] ?? ''),
                              onTap: () {
                                setState(() {
                                  selectedCity = city['text'] ?? '';
                                  if (isLocalCitySelected) {
                                    localCityController.text = selectedCity;
                                    localSelectedCityId = city['value'];
                                  } else {
                                    permanentCityController.text = selectedCity;
                                    permanentSelectedCityId = city['value'];
                                  }
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text('No records found',
                              style: TextStyle(fontSize: 16)),
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
}
