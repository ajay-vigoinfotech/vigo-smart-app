import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_pallete.dart';
import '../view model/family_relation_view_model.dart';
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

  @override
  void initState() {
    fetchBankListData();
    super.initState();
  }

  bool _expandAll = true;

  FamilyRelationViewModel familyRelationViewModel = FamilyRelationViewModel();
  List<Map<String, dynamic>> familyRelationData = [];
  List<Map<String, dynamic>> filterFamilyRelationData = [];
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
      setState(() {
        filterFamilyRelationData = familyRelationData;
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
                    // controller: dateController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd-MM-yyyy');
                            final parsedDate = inputFormat.parse(value);

                            final outputFormat = DateFormat('yyyy-MM-dd');
                            // dob = outputFormat.format(parsedDate);

                            // dateController.text = value;
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
                  ),
                  CustomTextFormField(
                    icon: Pallete.card.icon!,
                    labelText: "ESIC Number",
                  ),
                  CustomTextFormField(
                    icon: Pallete.card.icon!,
                    labelText: 'PF Number',
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Nominee Name',
                  ),
                  CustomTextFormField(
                    icon: Icons.calendar_month,
                    labelText: 'Nominee DOB',
                    isDatePicker: true,
                    // controller: dateController,
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value.isNotEmpty) {
                          try {
                            final inputFormat = DateFormat('dd-MM-yyyy');
                            final parsedDate = inputFormat.parse(value);

                            final outputFormat = DateFormat('yyyy-MM-dd');
                            // dob = outputFormat.format(parsedDate);

                            // dateController.text = value;
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
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Designation',
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Year of Experience',
                    keyboardType: TextInputType.number,
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
                            // dob = outputFormat.format(parsedDate);

                            // dateController.text = value;
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
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      TextButton(onPressed: (){},
                          child: Text('+ Add More',
                          style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500,color: Colors.redAccent
                          ),
                          ))
                    ],
                  ),
                  CustomTextFormField(
                    icon: Icons.person,
                    labelText: 'Designation',
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
                            // dob = outputFormat.format(parsedDate);

                            // dateController.text = value;
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
}
