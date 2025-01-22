import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/recruitment/model/update_recruitment03_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_4.dart';
import '../../../helper/toast_helper.dart';
import '../../auth/session_manager/session_manager.dart';
import '../view model/family_relation_view_model.dart';
import '../view model/pre_recruitment_by_id_view_model.dart';
import '../view model/update_recruitment03_view_model.dart';
import '../widget/custom_text_form_field.dart';

class RecruitmentStep3 extends StatefulWidget {
  final dynamic userId;
  final dynamic recruitedUserId;

  const RecruitmentStep3({
    super.key, required this.userId, this.recruitedUserId,
  });

  @override
  State<RecruitmentStep3> createState() => _RecruitmentStep3State();
}

class _RecruitmentStep3State extends State<RecruitmentStep3> {
  String? recruitedUserId;

  TextEditingController dojController = TextEditingController();
  TextEditingController uanNoController = TextEditingController();
  TextEditingController pfController = TextEditingController();
  TextEditingController nomineenameController = TextEditingController();
  TextEditingController nomineeRelationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController userIdController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    if (widget.recruitedUserId != null) {
      fetchPreRecruitmentByIdData().then((_) {
        fetchFamilyListData().then((_) {
        });
      });
    } else if (widget.userId != null) {
      fetchFamilyListData();
    }
  }

  //PreRecruitment By ID
  PreRecruitmentByIdViewModel preRecruitmentByIdViewModel = PreRecruitmentByIdViewModel();
  List<Map<String, dynamic>> preRecruitmentByIdData = [];

  Future<void> fetchPreRecruitmentByIdData() async {
    String? token = await preRecruitmentByIdViewModel.sessionManager.getToken();

    if (token != null) {
      await preRecruitmentByIdViewModel.fetchPreRecruitmentByIdList(token, widget.recruitedUserId);

      if (preRecruitmentByIdViewModel.getPreRecruitmentByIdList != null) {
        setState(() {
          preRecruitmentByIdData = preRecruitmentByIdViewModel.getPreRecruitmentByIdList!
              .map((entry) => {
            "userId": entry.userId,
            "doj" : entry.doj,
            "uanNo" : entry.uanNo,
            "esicNo" : entry.esicNo,
            "pfNo" : entry.pfNo,
            "nomineeName" : entry.nomineeName,
            "nomineeAge" : entry.nomineeAge,
            "nomineeRelation" : entry.nomineeRelation,
            "oldCompany" : entry.oldCompany,
            "oldDesignation" : entry.oldDesignation,
            "oldExperiance" : entry.oldExperiance,
            "oldCompanyLeavingDate" : entry.oldCompanyLeavingDate,
          })
              .toList();
          if (preRecruitmentByIdData.isNotEmpty) {
            recruitedUserId = preRecruitmentByIdData[0]["userId"] ?? "";

            dateOfJoin = preRecruitmentByIdData[0]["doj"] ?? "";
            dateOfJoin = formatDate(dateOfJoin);
            dojController.text = formatDate(dateOfJoin, inputFormat: 'yyyy-MM-dd', outputFormat: 'dd-MM-yyyy');

            uan = preRecruitmentByIdData[0]["uanNo"];
            uanController.text = uan;

            esic = preRecruitmentByIdData[0]["esicNo"];
            esicController.text = esic;

            pf = preRecruitmentByIdData[0]["pfNo"];
            pfController.text = pf;

            nomineename = preRecruitmentByIdData[0]["nomineeName"];
            nomineenameController.text = nomineename;

            nomineeage = preRecruitmentByIdData[0]["nomineeAge"] ?? "";
            nomineeage = formatDate(nomineeage);
            nomineeageController.text = formatDate(nomineeage, inputFormat: 'yyyy-MM-dd', outputFormat: 'dd-MM-yyyy');

            nomineeRelation = preRecruitmentByIdData[0]["nomineeRelation"] ?? "";
            nomineeRelationController.text = nomineeRelation;

            //previous job details
            companyName = preRecruitmentByIdData[0]["oldCompany"] ?? "";
            companyNameController.text = companyName;

            designation = preRecruitmentByIdData[0]["oldDesignation"] ?? "";
            designationController.text = designation;

            experience = preRecruitmentByIdData[0]["oldExperiance"] ?? "";
            experienceController.text = experience;

            companyLeavingDate = preRecruitmentByIdData[0]["oldCompanyLeavingDate"] ?? "";
            companyLeavingDate = formatDate(companyLeavingDate);
            companyLeavingDateController.text = formatDate(nomineeage, inputFormat: 'yyyy-MM-dd', outputFormat: 'dd-MM-yyyy');
          }
        });
      }
    }
  }


  List<Map<String, dynamic>> familyDetails = [
    {"dob": "", "name": "", "relation": "", "relationId": ""},
  ];

  // Map<String, dynamic> getFamilyDetailsJson() {
  //   List<Map<String, dynamic>> filteredDetails = familyDetails
  //       .map((entry) {
  //     // Create a copy of the map excluding 'displayDob'
  //     Map<String, dynamic> sanitizedEntry = Map.of(entry);
  //     sanitizedEntry.remove('displayDob');
  //
  //     // Replace empty strings with null
  //     return sanitizedEntry.map((key, value) => MapEntry(key, value.isEmpty ? null : value));
  //   })
  //       .where((entry) => entry.values.any((value) => value != null))
  //       .toList();
  //
  //   if (filteredDetails.isNotEmpty) {
  //     return {"familyDetails": filteredDetails};
  //   }
  //   return {};
  // }

  Map<String, dynamic> getFamilyDetailsJson() {
    List<Map<String, dynamic>> filteredDetails = familyDetails
        .map((entry) {
      // Create a copy of the map excluding 'displayDob'
      Map<String, dynamic> sanitizedEntry = Map.of(entry);
      sanitizedEntry.remove('displayDob');

      // Replace empty strings with null
      return sanitizedEntry.map((key, value) => MapEntry(key, value.isEmpty ? null : value));
    })
        .where((entry) => entry.values.any((value) => value != null))
        .toList();

    if (filteredDetails.isNotEmpty) {
      return {"familyDetails": filteredDetails};
    }
    return {};  // Return an empty map instead of null
  }



  // Map<String, dynamic> getFamilyDetailsJson() {
  //   return {"familyDetails": familyDetails};
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController uanController = TextEditingController();
  final TextEditingController esicController = TextEditingController();
  final TextEditingController nomineeageController = TextEditingController();
  final TextEditingController companyLeavingDateController = TextEditingController();


  String dateOfJoin = '';
  String uan = '';
  String esic = '';
  String pf = '';
  String nomineename = '';

  String nomineeage = '';
  String formattednomineeage = '';

  String nomineeRelation = '';
  String companyName = '';
  String designation = '';
  String experience = '';
  String companyLeavingDate = '';
  String formattedcompanyLeavingDate = '';

  SessionManager sessionManager = SessionManager();

  bool _expandAll = true;

  //Get Family Relation
  FamilyRelationViewModel familyRelationViewModel = FamilyRelationViewModel();
  List<Map<String, dynamic>> familyRelationData = [];
  String selectedFamilyRelationName = '';
  String selectedFamilyRelationNameId = '';

  Future<void> fetchFamilyListData() async {
    String? token = await familyRelationViewModel.sessionManager.getToken();
    if (token != null) {
      await familyRelationViewModel.fetchFamilyRelationList(token);

      setState(() {
        if (familyRelationViewModel.familyRelationList != null) {
          familyRelationData = familyRelationViewModel.familyRelationList!
              .map((entry) => {
            "familyRelatonId": entry.familyRelatonId,
            "familyRelationCode": entry.familyRelationCode,
            "familyRelationName": entry.familyRelationName,
          })
              .toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 3'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _expandAll = !_expandAll;
              });
            },
            icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _companyDetails(),
              _previousJobDetails(),
              _familyDetails(),
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
                      if (_formKey.currentState!.validate()) {
                        String jsonOutput = jsonEncode(getFamilyDetailsJson());
                        debugPrint(jsonOutput);
                        if (jsonOutput == '{}' || jsonOutput.isEmpty) {
                          jsonOutput = '';
                        }
                    
                        try{
                          String? token = await sessionManager.getToken();
                          UpdateRecruitment03ViewModel updateRecruitment03ViewModel = UpdateRecruitment03ViewModel();
                    
                          Map<String,dynamic> response = await updateRecruitment03ViewModel.updateRecruitment03(token!,
                              UpdateRecruitment03Model(
                                userId: widget.userId ?? widget.recruitedUserId,
                                dateOfJoin: dateOfJoin,
                                UAN: uan,
                                ESIC: esic,
                                PF: pf,
                                nomineename: nomineename,
                                nomineeage: nomineeage,
                                nomineeRelation: nomineeRelation,
                                company_name: companyName,
                                Designation: designation,
                                experience: experience,
                                company_address: '',
                                company_leavingDate: companyLeavingDate,
                                familyDetails: jsonOutput,
                              )
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
                                      builder: (context) => RecruitmentStep4(
                                        userId: widget.userId,
                                          recruitedUserId : widget.recruitedUserId,
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
                              text: '${response['message'] ?? 'Something went wrong'}',
                            );
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('An error occurred. Please try again later.')),
                          );
                        }
                      } else {
                        ToastHelper.showToast(
                          message: "Please correct the errors in the form.", context: context,
                        );
                      }
                    },
                        child : FittedBox(
                          child: Text('Submit and Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  SizedBox(width: 5),
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
                        onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          RecruitmentStep4(
                              userId: widget.userId,
                              recruitedUserId :widget.recruitedUserId
                          ),
                      ),
                      );
                    },
                        child: FittedBox(
                          child: Text('Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        ),),
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

  Widget _companyDetails() {
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
          title: Text('Company Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    iconWidget: Icon(Icons.calendar_month, color: Colors.indigo, size: 30,),
                    labelText: 'Date of Join',
                    isDatePicker: true,
                    controller: dojController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          dateOfJoin = formatDate(value, inputFormat: 'dd-MM-yyyy', outputFormat: 'yyyy-MM-dd');
                          dojController.text = value; // Keep the display format
                        }
                      });
                    },
                  ),
                  CustomTextFormField(
                    controller: uanController,
                    iconWidget: Icon(Icons.credit_card, color: Colors.indigo, size: 30,),
                    labelText: "UAN Number",
                    onChanged: (value) {
                      uan = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: esicController,
                    iconWidget: Icon(Icons.credit_card, color: Colors.indigo, size: 30,),
                    labelText: "ESIC Number",
                    onChanged: (value) {
                      esic = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: pfController,
                    iconWidget: Icon(Icons.credit_card, color: Colors.indigo, size: 30,),
                    labelText: 'PF Number',
                    onChanged: (value) {
                      pf = value!;
                    },
                  ),
                  CustomTextFormField(
                    controller: nomineenameController,
                    iconWidget: Icon(Icons.person, color: Colors.indigo, size: 30,),
                    labelText: 'Nominee Name',
                    onChanged: (value) {
                      nomineename = value!;
                    },
                  ),

                  CustomTextFormField(
                    iconWidget: Icon(Icons.calendar_month, color: Colors.indigo, size: 30,),
                    labelText: 'Nominee DOB',
                    isDatePicker: true,
                    controller: nomineeageController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          nomineeage = formatDate(value, inputFormat: 'dd-MM-yyyy', outputFormat: 'yyyy-MM-dd'); // Format for API
                          nomineeageController.text = value; // Keep the display format
                        }
                      });
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Icon(Icons.credit_card, color: Colors.indigo, size: 30,),
                    labelText: 'Relation with Nominee',
                    controller: nomineeRelationController,
                    onChanged: (value) {
                      nomineeRelation = value!;
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

  Widget _previousJobDetails() {
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
          title: Text('Previous Job Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    iconWidget: Icon(Icons.business_sharp, color: Colors.indigo, size: 30,),
                    labelText: 'Company Name',
                    controller: companyNameController,
                    onChanged: (value) {
                      companyName = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Icon(Icons.person, color: Colors.indigo, size: 30,),
                    labelText: 'Designation',
                    controller: designationController,
                    onChanged: (value) {
                      designation = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Icon(Icons.person, color: Colors.indigo, size: 30,),
                    labelText: 'Year of Experience',
                    controller: experienceController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      experience = value!;
                    },
                  ),
                  CustomTextFormField(
                    iconWidget: Icon(Icons.calendar_month, color: Colors.indigo, size: 30,),
                    labelText: 'Date of Leaving',
                    isDatePicker: true,
                    controller: companyLeavingDateController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          companyLeavingDate = formatDate(value, inputFormat: 'dd-MM-yyyy', outputFormat: 'yyyy-MM-dd');
                          companyLeavingDateController.text = value;
                        }
                      });
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

  Widget _familyDetails() {
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
          title: Text('Family Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (familyDetails.length < 7) {
                            setState(() {
                              familyDetails.add({
                                "dob" : "",
                                "name" : "",
                                "relation" : "",
                                "relationId" : "",
                              });
                            });
                        } else {
                            ToastHelper.showToast(
                              message: "You can add a maximum of 7 family members.", context: context,);
                            return;
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

                  Form(
                    key: _formKey,
                    child: Column(
                      children: familyDetails.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> detail = entry.value;
                        return Column(
                          key: ValueKey(detail),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    iconWidget: Icon(Icons.person, color: Colors.indigo, size: 30,),
                                    labelText: 'Name (As Per Aadhaar)',
                                    onChanged: (value) {
                                      setState(() {
                                        detail['name'] = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (_isAnyFieldFilled(detail) && value!.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            CustomTextFormField(
                              iconWidget: Icon(Icons.calendar_month, color: Colors.indigo, size: 30,),
                              labelText: 'Date of Birth',
                              isDatePicker: true,
                              onChanged: (formattedDate) {
                                if (formattedDate != null) {
                                  // Parse and format the date for JSON
                                  try {
                                    final parts = formattedDate.split('-');
                                    if (parts.length == 3) {
                                      final day = parts[0].padLeft(2, '0');
                                      final month = parts[1].padLeft(2, '0');
                                      final year = parts[2];

                                      final jsonDate = "$year-$month-$day";

                                      setState(() {
                                        detail['displayDob'] = formattedDate; // Internal use only
                                        detail['dob'] = jsonDate; // For JSON
                                      });
                                    }
                                  } catch (e) {
                                    debugPrint('Error formatting date: $e');
                                  }
                                }
                              },
                              controller: TextEditingController(
                                text: detail['displayDob'] ?? '',
                              ),
                              validator: (value) {
                                if (_isAnyFieldFilled(detail) && (value == null || value.trim().isEmpty)) {
                                  return 'Date of Birth is required';
                                }
                                return null;
                              },
                            ),

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
                                    value: detail['relationId'].isNotEmpty
                                        ? detail['relationId']
                                        : familyRelationData.isNotEmpty
                                        ? familyRelationData[0]["familyRelatonId"].toString()
                                        : null,
                                    hint: detail['relationId'].isEmpty && familyRelationData.isNotEmpty
                                        ? Text(
                                      familyRelationData[0]["familyRelationName"] ?? '',
                                      style: const TextStyle(color: Colors.black54),
                                    )
                                        : null,
                                    items: familyRelationData.map((relation) {
                                      return DropdownMenuItem<String>(
                                        value: relation["familyRelatonId"].toString(),
                                        child: Text(relation["familyRelationName"] ?? ""),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        detail['relation'] = familyRelationData
                                            .firstWhere((relation) => relation["familyRelatonId"].toString() == newValue)["familyRelationName"];
                                        detail['relationId'] = newValue ?? '';
                                      });
                                    },
                                    underline: const SizedBox(),
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),

                            // SizedBox(
                            //   width: double.infinity,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Container(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 12.0, vertical: 8.0),
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(8.0),
                            //         border: Border.all(color: Colors.grey, width: 1),
                            //       ),
                            //       child: DropdownButton<String>(
                            //         isExpanded: true,
                            //         value: detail['relationId'].isNotEmpty
                            //             ? detail['relationId']
                            //             : null,
                            //         hint: const Text(
                            //           'Select Family Relation',
                            //           style: TextStyle(color: Colors.black54),
                            //         ),
                            //         items: familyRelationData.map((relation) {
                            //           return DropdownMenuItem<String>(
                            //             value: relation["familyRelatonId"].toString(),
                            //             child: Text(relation["familyRelationName"] ?? ""),
                            //           );
                            //         }).toList(),
                            //         onChanged: (String? newValue) {
                            //           setState(() {
                            //             detail['relation'] = familyRelationData
                            //                 .firstWhere((relation) => relation["familyRelatonId"].toString() == newValue)["familyRelationName"];
                            //             detail['relationId'] = newValue ?? '';
                            //           });
                            //         },
                            //         underline: const SizedBox(),
                            //         icon: const Icon(Icons.arrow_drop_down,
                            //             color: Colors.black),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (index != 0)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        familyDetails.removeAt(index);
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAnyFieldFilled(Map<String, dynamic> detail) {
    return detail['name']!.isNotEmpty ||
        detail['dob']!.isNotEmpty ||
        detail['relationId']!.isNotEmpty;
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
