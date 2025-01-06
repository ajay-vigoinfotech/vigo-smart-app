import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/recruitment/model/update_recruitment04_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/pre_recruitment_list.dart';
import '../../../helper/toast_helper.dart';
import '../../auth/session_manager/session_manager.dart';
import '../view model/document_type_view_model.dart';
import '../view model/update_recruitment04_view_model.dart';
import '../widget/custom_text_form_field.dart';

import 'package:image/image.dart' as img;

class RecruitmentStep4 extends StatefulWidget {
  final dynamic userId;

  const RecruitmentStep4({super.key, required this.userId});

  @override
  State<RecruitmentStep4> createState() => _RecruitmentStep4State();
}

class _RecruitmentStep4State extends State<RecruitmentStep4> {

  List<Map<String, dynamic>> otherDocx = [
    {"base64": "", "documentType": "", "documentTypeId": ""},
  ];

  Map<String, dynamic> otherDocxJson() {
    // Filter out entries with empty base64
    final filteredOtherDocx = otherDocx.where((doc) => doc["base64"]!.isNotEmpty).toList();

    return filteredOtherDocx.isNotEmpty ? {"otherDocx": filteredOtherDocx} : {};
  }

  bool _expandAll = true;
  SessionManager sessionManager = SessionManager();
  String height = '';
  String weight = '';
  String waist = '';
  String chest = '';
  String identificationMark = '';
  String bloodGroup = '';


  @override
  void initState() {
    fetchBankListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 4'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PreRecruitmentList()));
            // setState(() {
            //   _expandAll = !_expandAll;
            // });
          },
              icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _physicalDetails(),
              _otherDocuments(),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () async {
                    String jsonOutput = jsonEncode(otherDocxJson());
                    // debugPrint(jsonOutput);
                    try{
                      String? token = await sessionManager.getToken();
                      UpdateRecruitment04ViewModel updateRecruitment04ViewModel = UpdateRecruitment04ViewModel();

                      Map<String, dynamic> response = await updateRecruitment04ViewModel.updateRecruitment04(token!,
                          UpdateRecruitment04Model(
                              userId: widget.userId,
                              Height: height,
                              Weight: weight,
                              physical_waist: waist,
                              physical_chest: chest,
                              physical_shoe: identificationMark,
                              physical_blood: bloodGroup,
                              DocumentsList: jsonOutput,
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => RecruitmentStep4(
                              //       userId: '${widget.userId}',
                              //     ),
                              //   ),
                              // );
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
                      child: Text('Save and Submit'), ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _physicalDetails() {
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
          title: Text('Company Details'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    iconWidget: Image.asset('assets/images/height.png', color: Colors.blue.shade900,),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true
                    ),
                    labelText: "Height (in CMs)",
                    onChanged: (value) {
                      height = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Image.asset('assets/images/scale.png', color: Colors.teal.shade900,),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                    ),
                    labelText: "Weight (in KGs)",
                    onChanged: (value) {
                      weight = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Image.asset('assets/images/waist.png',
                    color: Colors.green.shade900,
                    ),

                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                    ),
                    // icon: Icons.fitness_center,
                    labelText: "Waist (in inches)",
                    onChanged: (value) {
                      waist = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Image.asset('assets/images/chest.png', color: Colors.brown.shade900,),

                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                    ),
                    // icon: Icons.archive,
                    labelText: "Chest (in inches)",
                    onChanged: (value) {
                      chest = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Icon(Icons.accessibility_new, color: Colors.indigo.shade900, size: 30,),
                    labelText: 'Identification Mark',
                    onChanged: (value) {
                      identificationMark = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Icon(Icons.bloodtype, color: Colors.red, size: 30,),
                    labelText: 'Blood Group',
                    onChanged: (value) {
                      bloodGroup = value!;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Get Document Type
  DocumentTypeViewModel documentTypeViewModel = DocumentTypeViewModel();
  List<Map<String, dynamic>> documentTypeData = [];
  String selectedDocumentType = '';
  String selectedDocumentTypeId = '';

  Future<void> fetchBankListData() async {
    String? token = await documentTypeViewModel.sessionManager.getToken();
    if (token != null) {
      await documentTypeViewModel.fetchDocumentType(token);

      setState(() {
        if (documentTypeViewModel.documentTypeList != null) {
          documentTypeData = documentTypeViewModel.documentTypeList!
              .map((entry) => {
            "value": entry.value,
            "text": entry.text,
            "parentId": entry.parentId,
          })
              .toList();
        }
      });
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How do you want to select image?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.camera, index);
              },
            ),
            ListTile(
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage(ImageSource.gallery, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, int index) async {
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
        final resizedImage = img.copyResize(decodedImage, width: 1080);
        final compressedImage = img.encodeJpg(resizedImage, quality: 80);
        final base64String = base64Encode(compressedImage);

        setState(() {
          // _documentImage = base64String; // Update the class-level variable
          otherDocx[index]["base64"] = base64String; // Update the specific JSON entry
        });
      }
    }
  }

  void _deleteImage(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete the image?'),
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
        // _documentImage = '';
        otherDocx[index]["base64"] = ''; // Clear the base64 for the specific document
      });
    }
  }


  Widget _otherDocuments() {
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
          title: Text('Other Documents'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (otherDocx.length < 7) {
                                  setState(() {
                                    otherDocx.add({
                                      "base64": "",
                                      "documentType": "",
                                      "documentTypeId": "",
                                    });
                                  });
                                } else {
                                  ToastHelper.showToast(
                                    message: "You can add a maximum of 7 documents.",
                                  );
                                }
                              },
                              child: Text(
                                '+ Add More',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: otherDocx.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> type = entry.value;
                            return Column(
                              key: ValueKey(index),
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: Colors.grey, width: 1),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: type['documentTypeId'].isNotEmpty
                                            ? type['documentTypeId']
                                            : documentTypeData.isNotEmpty
                                            ? documentTypeData[0]["value"].toString()
                                            : null,
                                        hint: type['documentTypeId'].isEmpty && documentTypeData.isNotEmpty
                                            ? Text(
                                          documentTypeData[0]["text"] ?? '',
                                          style: const TextStyle(color: Colors.black54),
                                        )
                                            : null,
                                        items: documentTypeData.isNotEmpty
                                            ? documentTypeData.map((/*document*/type) {
                                          return DropdownMenuItem<String>(
                                            value: type["value"].toString(),
                                            child: Text(type["text"] ?? ""),
                                          );
                                        }).toList()
                                            : [],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            final selectedDocument = documentTypeData.firstWhere(
                                                  (document) => document["value"].toString() == newValue,
                                            );
                                            type['documentType'] = selectedDocument["text"];
                                            type['documentTypeId'] = newValue ?? '';
                                          });
                                        },
                                        underline: const SizedBox(),
                                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _selectImage(index),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: double.infinity,
                                            maxHeight: 400,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.grey[200],
                                          ),
                                          child: type["base64"]!.isEmpty
                                              ? Image.asset('assets/images/add_docs_placeholder.webp')
                                              : ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.memory(
                                              base64Decode(type["base64"]!),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      GestureDetector(
                                        onTap: () => _deleteImage(index),
                                        child: Text(
                                          'Remove Image',
                                          style: TextStyle(fontSize: 17, color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (index != 0)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            otherDocx.removeAt(index);
                                          });
                                        },
                                        child: Text(
                                          '- Remove',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Divider(thickness: 2, color: Colors.grey),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
