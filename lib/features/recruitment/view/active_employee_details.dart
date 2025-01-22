import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';

import '../view model/pre_recruitment_by_id_view_model.dart';

class ActiveEmployeeDetails extends StatefulWidget {
  final dynamic recruitedUserId;
  const ActiveEmployeeDetails({super.key, required this.recruitedUserId});

  @override
  State<ActiveEmployeeDetails> createState() => _ActiveEmployeeDetailsState();
}

class _ActiveEmployeeDetailsState extends State<ActiveEmployeeDetails> {
  PreRecruitmentByIdViewModel preRecruitmentByIdViewModel =
      PreRecruitmentByIdViewModel();
  List<Map<String, dynamic>> preRecruitmentByIdData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    fetchPreRecruitmentByIdData();
  }

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
                        "aadharNum": entry.aadharNum,
                        "pan": entry.pan,
                        "employeeCode": entry.employeeCode,
                        "aadhaarDocs": entry.aadhaarDocs,
                        "fullName": entry.fullName,
                        "firstName": entry.firstName,
                        "lastName": entry.lastName,
                        "email": entry.email,
                        "fatherName": entry.fatherName,
                        "motherName": entry.motherName,
                        "spouseName": entry.spouseName,
                        "mobilePIN": entry.mobilePIN,
                        "dob": entry.dob,
                        "gender": entry.gender,
                        "ifscCode": entry.ifscCode,
                        "accntNo": entry.accntNo,
                        "bankName": entry.bankName,
                        "uanNo": entry.uanNo,
                        "esicNo": entry.esicNo,
                        "pfNo": entry.pfNo,
                        "doj": entry.doj,
                        "createDate": entry.createDate,
                        "emergencyName1": entry.emergencyName1,
                        "emergencyContactDetails1": entry.emergencyContactDetails1,
                        "bloodGroup": entry.bloodGroup,
                        "image": entry.image,
                        "designationName": entry.designationName,
                        "currentAddress": entry.currentAddress,
                        "permanentAddress": entry.permanentAddress,
                        "spouseAge": entry.spouseAge,
                      })
                  .toList();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruited Employee Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: preRecruitmentByIdData.length,
              itemBuilder: (context, index) {
                final data = preRecruitmentByIdData[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Image.network(
                            '${AppConstants.baseUrl}/${data['image']}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 100),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InfoText(
                              value: data['fullName'],
                              fallback: '-',
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            InfoText(
                              value: data['email'],
                              fallback: '-',
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InfoText(
                                value: data['designationName'],
                                fallback: '-',
                                style: const TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 20,
                            width: 2,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InfoText(
                                value: data['mobilePIN'],
                                fallback: '-',
                                style: const TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(thickness: 4),
                      SizedBox(height: 5,),
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Image.asset(
                              'assets/images/personal_details.webp',
                              width: 60,
                              height: 60,
                            ),
                            title: const Text(
                              'Basic Information',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: const Text(
                              'See Employee Personal Details',
                              style: TextStyle(color: Colors.black54),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoText(
                                        value: 'Emp Code : ${data['employeeCode']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Fathers\'s Name : ${data['fatherName']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Date of birth : ${data['dob']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Gender : ${data['gender'] == "1" ? "Male" : data['gender'] == "2" ? "Female" : "-"}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Current Address : ${data['currentAddress']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Permanent Address : ${data['permanentAddress']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Spouse Name : ${data['spouseName']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Spouse DOB : ${data['spouseAge']}',
                                        fallback: 'test test',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Blood Group : ${data['bloodGroup']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Emergency Contact Person : ${data['emergencyName1']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Emergency Contact Number : ${data['emergencyContactDetails1']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Image.asset(
                              'assets/images/office_building.webp',
                              width: 60,
                              height: 60,
                            ),
                            title: const Text(
                              'Company Details',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: const Text(
                              'See company details of Employee',
                              style: TextStyle(color: Colors.black54),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoText(
                                        value: 'Date of Joining : ${data['doj']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Create Date : ${data['createDate']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Image.asset(
                              'assets/images/document.webp',
                              width: 60,
                              height: 60,
                            ),
                            title: const Text(
                              'Documents',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: const Text(
                              'See Documents submitted',
                              style: TextStyle(color: Colors.black54),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoText(
                                        value: 'Aadhaar Number : ${data['aadharNum']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Pan Number : ${data['pan']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'PF Number : ${data['pfNo']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'ESIC Number : ${data['esicNo']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'UAN Number : ${data['uanNo']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Image.asset(
                              'assets/images/bank.webp',
                              width: 60,
                              height: 60,
                            ),
                            title: const Text(
                              'Bank Details',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: const Text(
                              'See Employee bank details',
                              style: TextStyle(color: Colors.black54),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InfoText(
                                        value: 'Bank Name : ${data['bankName']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'Account Number : ${data['accntNo']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      InfoText(
                                        value: 'IFSC Number : ${data['ifscCode']}',
                                        fallback: '-',
                                        style: const TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
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

class InfoText extends StatelessWidget {
  final String? value;
  final String fallback;
  final TextStyle? style;

  const InfoText({
    super.key,
    required this.value,
    this.fallback = 'Not available',
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      (value != null && value!.isNotEmpty) ? value! : fallback,
      style: style ?? const TextStyle(color: Colors.grey),
    );
  }
}
