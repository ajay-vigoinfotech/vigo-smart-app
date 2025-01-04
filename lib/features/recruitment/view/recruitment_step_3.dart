import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vigo_smart_app/features/recruitment/model/update_recruitment03_model.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_4.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../helper/toast_helper.dart';
import '../../auth/session_manager/session_manager.dart';
import '../view model/family_relation_view_model.dart';
import '../view model/update_recruitment03_view_model.dart';
import '../widget/custom_text_form_field.dart';

class RecruitmentStep3 extends StatefulWidget {
  final dynamic userId;

  const RecruitmentStep3({
    super.key,
    required this.userId,
  });

  @override
  State<RecruitmentStep3> createState() => _RecruitmentStep3State();
}

class _RecruitmentStep3State extends State<RecruitmentStep3> {

  List<Map<String, dynamic>> familyDetails = [
    {"dob": "", "name": "", "relation": "", "relationId": ""},
  ];

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
    return {};
  }


  // Map<String, dynamic> getFamilyDetailsJson() {
  //   return {"familyDetails": familyDetails};
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController dateOfJoinController = TextEditingController();
  final TextEditingController uanController = TextEditingController();
  final TextEditingController nomineeageController = TextEditingController();
  final TextEditingController companyLeavingDateController = TextEditingController();


  String dateOfJoin = '';
  String uan = '';
  String esic = '';
  String pf = '';
  String nomineename = '';
  String nomineeage = '';
  String nomineeRelation = '';
  String companyName = '';
  String designation = '';
  String experience = '';
  String companyLeavingDate = '';

  SessionManager sessionManager = SessionManager();


  @override
  void initState() {
    fetchBankListData();
    super.initState();
  }

  bool _expandAll = true;

  //Get Family Relation
  FamilyRelationViewModel familyRelationViewModel = FamilyRelationViewModel();
  List<Map<String, dynamic>> familyRelationData = [];
  String selectedFamilyRelationName = '';
  String selectedFamilyRelationNameId = '';

  Future<void> fetchBankListData() async {
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
              _contactDetails(),
              _previousJobDetails(),
              _familyDetails(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String jsonOutput = jsonEncode(getFamilyDetailsJson());
                      debugPrint(jsonOutput);

                      try{
                        String? token = await sessionManager.getToken();
                        UpdateRecruitment03ViewModel updateRecruitment03ViewModel = UpdateRecruitment03ViewModel();

                        Map<String,dynamic> response = await updateRecruitment03ViewModel.updateRecruitment03(token!,
                            UpdateRecruitment03Model(
                              userId: widget.userId,
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
                                      userId: '${widget.userId}',
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
                    } else {
                      ToastHelper.showToast(
                        message: "Please correct the errors in the form.",
                      );
                    }

                  },
                      child : Text('Submit and Next')),
                  ElevatedButton(onPressed: (){},
                      child: Text('Next'))
                ],
              ),
            ],
          ),
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
                    icon: Icons.calendar_month,
                    labelText: 'Date of Joining',
                    isDatePicker: true,
                    controller: dateOfJoinController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd-MM-yyyy');
                            final parsedDate = inputFormat.parse(value);

                            final outputFormat = DateFormat('yyyy-MM-dd');
                            dateOfJoin = outputFormat.format(parsedDate);

                            dateOfJoinController.text = value;
                          } catch (e) {
                            debugPrint('Error parsing date: $e');
                          }
                        }
                      });
                    },
                  ),
                  CustomTextFormField(
                    icon: Pallete.card.icon!,
                    labelText: "UAN Number",
                    onChanged: (value) {
                      uan = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Pallete.card.icon!,
                    labelText: "ESIC Number",
                    onChanged: (value) {
                      esic = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Pallete.card.icon!,
                    labelText: 'PF Number',
                    onChanged: (value) {
                      pf = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Nominee Name',
                    onChanged: (value) {
                      nomineename = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.calendar_month,
                    labelText: 'Nominee DOB',
                    isDatePicker: true,
                    controller: nomineeageController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd-MM-yyyy');
                            final parsedDate = inputFormat.parse(value);

                            final outputFormat = DateFormat('yyyy-MM-dd');
                            nomineeage = outputFormat.format(parsedDate);

                            nomineeageController.text = value;
                          } catch (e) {
                            debugPrint('Error parsing date: $e');
                          }
                        }
                      });
                    },
                  ),
                  CustomTextFormField(
                    icon: Pallete.card.icon!,
                    labelText: 'Relation with Nominee',
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
          title: Text('Previous Job Details'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextFormField(
                    icon: Icons.business_sharp,
                    labelText: 'Company Name',
                    onChanged: (value) {
                      companyName = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Designation',
                    onChanged: (value) {
                      designation = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Year of Experience',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      experience = value!;
                    },
                  ),
                  CustomTextFormField(
                    icon: Icons.calendar_month,
                    labelText: 'Date of Leaving',
                    isDatePicker: true,
                    // controller: dateController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd-MM-yyyy');
                            final parsedDate = inputFormat.parse(value);

                            final outputFormat = DateFormat('yyyy-MM-dd');
                            companyLeavingDate = outputFormat.format(parsedDate);

                            companyLeavingDateController.text = value;
                          } catch (e) {
                            debugPrint('Error parsing date: $e');
                          }
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
          title: Text('Family Details'),
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
                              message: "You can add a maximum of 7 family members.",);
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
                                    icon: Icons.person,
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
                              icon: Icons.calendar_month,
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
            )
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

}
