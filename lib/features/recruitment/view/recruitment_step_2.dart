import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/theme/app_pallete.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_1.dart';
import 'package:vigo_smart_app/features/recruitment/widget/custom_text_form_field.dart';

import '../view model/bank_list_view_model.dart';
import '../view model/get_city_view_model.dart';
import '../view model/get_state_view_model.dart';

class RecruitmentStep2 extends StatefulWidget {
  const RecruitmentStep2({super.key});

  @override
  State<RecruitmentStep2> createState() => _RecruitmentStep2State();
}

class _RecruitmentStep2State extends State<RecruitmentStep2> {
  final bool _expandAll = true;

  @override
  void initState() {
    fetchStateData();
    fetchCityData();
    fetchBankListData();
    super.initState();
  }

  // Get State List
  GetStateViewModel getStateViewModel = GetStateViewModel();
  List stateListData = [];

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

  //Get City List
  GetCityViewModel getCityViewModel = GetCityViewModel();
  List stateCityData = [];

  Future<void> fetchCityData() async {
    String? token = await getCityViewModel.sessionManager.getToken();

    if (token != null) {
      await getCityViewModel.fetchCityList(token);

      if (getCityViewModel.cityList != null) {
        setState(() {
          stateCityData = getCityViewModel.cityList!
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
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController stateController = TextEditingController();

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
          title: Text('Local Address'),
          children: [
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Line 1'),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Pincode'),
            CustomTextFormField(
              icon: Icons.location_on,
              iconColor: Pallete.green,
              labelText: 'State',
              controller: stateController,
            ),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'District'),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Police Station'),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Post Office'),
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

                  // checkColor: Colors.green,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                Text('SAME AS ABOVE (Local Address)'),
              ],
            ),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Line 1'),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Pincode'),
            CustomTextFormField(
              icon: Icons.location_on,
              iconColor: Pallete.green,
              labelText: 'State',
              controller: stateController,
            ),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'District'),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Police Station'),
            CustomTextFormField(
                iconColor: Pallete.green,
                icon: Pallete.location.icon!,
                labelText: 'Post Office'),
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
            _selectBank()
          ],
        ),
      ),
    );
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
                                      selectedBankId = bank['bankId'];
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
}
