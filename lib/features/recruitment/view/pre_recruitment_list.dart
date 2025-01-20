import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/recruitment/view/recruitment_step_1.dart';

import '../../../core/constants/constants.dart';
import '../view model/pre_recruitment_list_view_model.dart';
import 'active_employee_details.dart';

class PreRecruitmentList extends StatefulWidget {
  const PreRecruitmentList({super.key});

  @override
  State<PreRecruitmentList> createState() => _PreRecruitmentListState();
}

class _PreRecruitmentListState extends State<PreRecruitmentList> {
  PreRecruitmentListViewModel preRecruitmentListViewModel = PreRecruitmentListViewModel();
  List<Map<String, dynamic>> preRecruitmentListData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    fetchPreRecruitmentListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruited Employee List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search here",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: fetchPreRecruitmentListData,
                    child: filteredData.isEmpty
                        ? Center(
                            child: Text('No Data Available'),
                          )
                        : ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         RecruitmentStep1(
                                  //           recruitedUserId: filteredData[index]['userId'],
                                  //         ),
                                  //   ),
                                  // );

                                  if (data['statusId'] == "1") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecruitmentStep1(
                                          recruitedUserId: data['userId'],
                                        ),
                                      ),
                                    );
                                  } else if(data['statusId'] == "6") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActiveEmployeeDetails(
                                          recruitedUserId: data['userId'],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildColumn(
                                        borderColor: Colors.black,
                                        date: data['createDate'],
                                        statusName: data['statusName'] ?? '',
                                        imageUrl: '${AppConstants.baseUrl}/${data["image"]}',
                                        empCode: data['employeeCode'],
                                        name: data['fullName'],
                                        mobileNo: data['mobilePIN'],
                                        statusId: data['statusId'],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
          ),
        ],
      ),
    );
  }

  Future<void> fetchPreRecruitmentListData() async {
    String? token = await preRecruitmentListViewModel.sessionManager.getToken();

    if (token != null) {
      await preRecruitmentListViewModel.fetchPreRecruitmentList(token);

      if (preRecruitmentListViewModel.getPreRecruitmentList != null) {
        if (mounted) {
          setState(() {
            preRecruitmentListData =
                preRecruitmentListViewModel.getPreRecruitmentList!
                    .map((entry) => {
                  "userId": entry.userId,
                  "employeeCode": entry.employeeCode,
                  "fullName": entry.fullName,
                  "mobilePIN": entry.mobilePIN,
                  "image": entry.image,
                  "createDate": entry.createDate,
                  "statusId": entry.statusId,
                  "statusCode": entry.statusCode,
                  "statusName": entry.statusName,
                  "designationName": entry.designationName,
                })
                    .toList();
            filteredData = preRecruitmentListData;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = preRecruitmentListData;
      });
    } else {
      setState(() {
        filteredData = preRecruitmentListData.where((entry) {
          final userId = entry['userId']?.toLowerCase() ?? '';
          final employeeCode = entry['employeeCode']?.toLowerCase() ?? '';
          final fullName = entry['fullName']?.toLowerCase() ?? '';
          final mobilePIN = entry['mobilePIN']?.toLowerCase() ?? '';
          final image = entry['image']?.toLowerCase() ?? '';
          final createDate = entry['createDate']?.toLowerCase() ?? '';
          final statusId = entry['statusId']?.toLowerCase() ?? '';
          final statusCode = entry['statusCode']?.toLowerCase() ?? '';
          final statusName = entry['statusName']?.toLowerCase() ?? '';
          final designationName = entry['designationName']?.toLowerCase() ?? '';

          return userId.contains(query.toLowerCase()) ||
              employeeCode.contains(query.toLowerCase()) ||
              fullName.contains(query.toLowerCase()) ||
              mobilePIN.contains(query.toLowerCase()) ||
              image.contains(query.toLowerCase()) ||
              createDate.contains(query.toLowerCase()) ||
              statusId.contains(query.toLowerCase()) ||
              statusCode.contains(query.toLowerCase()) ||
              statusName.contains(query.toLowerCase()) ||
              designationName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Widget _buildColumn({
    required Color borderColor,
    required String date,
    required String statusName,
    required String imageUrl,
    required String empCode,
    required String name,
    required String mobileNo,
    required String statusId,
  }) {

    LinearGradient gradient = _getGradientForStatus(statusId);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  statusName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 85,
                    width: 85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/place_holder.webp'),
                      )
                          : Image.asset('assets/images/place_holder.webp'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 85,
                  width: 1,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emp Code: $empCode',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Name: $name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Mobile: $mobileNo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

LinearGradient _getGradientForStatus(String statusId) {
  switch (statusId) {
    case "1":
      return LinearGradient(
        colors: [Colors.white70, Colors.yellow.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case "6":
      return LinearGradient(
        colors: [Colors.white70, Colors.green.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case "2":
      return LinearGradient(
        colors: [Colors.white70, Colors.red.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    default:
      return LinearGradient(
        colors: [Colors.white70, Colors.indigo.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
  }
}
