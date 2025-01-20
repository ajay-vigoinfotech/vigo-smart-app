import 'package:flutter/material.dart';

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
                        "designationId": entry.designationId,
                        "designationName": entry.designationName,
                        "branch": entry.branch,
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
                            'http://ios.smarterp.live/${data['image']}',
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
                        child: Text(
                          '${data['fullName']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${data['designationName']}'),
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          Text('${data['mobilePIN']}'),
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
                              width: 50,
                              height: 50,
                            ),
                            title: const Text(
                              'Basic Information',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              'See Employee Personal Details',
                              style: TextStyle(color: Colors.grey),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Emp Code : ${data['fullName']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
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
                              width: 50,
                              height: 50,
                            ),
                            title: const Text(
                              'Basic Information',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              'See Employee Personal Details',
                              style: TextStyle(color: Colors.grey),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Emp Code : ${data['fullName']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
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
                              width: 50,
                              height: 50,
                            ),
                            title: const Text(
                              'Basic Information',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              'See Employee Personal Details',
                              style: TextStyle(color: Colors.grey),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Emp Code : ${data['fullName']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
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
                              width: 50,
                              height: 50,
                            ),
                            title: const Text(
                              'Basic Information',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              'See Employee Personal Details',
                              style: TextStyle(color: Colors.grey),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Emp Code : ${data['fullName']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
                                      Text('Emp Code : ${data['employeeCode']}'),
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
}
