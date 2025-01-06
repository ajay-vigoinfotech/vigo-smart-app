
import 'package:flutter/material.dart';

import '../view model/pre_recruitment_list_view_model.dart';

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

  Future<void> fetchPreRecruitmentListData() async {
    String? token =
    await preRecruitmentListViewModel.sessionManager.getToken();

    if (token != null) {
      await preRecruitmentListViewModel.fetchPreRecruitmentList(token);

      if (preRecruitmentListViewModel.getPreRecruitmentList != null) {
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
              })
                  .toList();
          filteredData = preRecruitmentListData;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

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
              // controller: searchController,
              // onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search here",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
