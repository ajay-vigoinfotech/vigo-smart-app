import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../view model/team_view_activity_patrolling_list_view_model.dart';

class TeamViewActivityPatrollingList extends StatefulWidget {
  final String userId;

  const TeamViewActivityPatrollingList({super.key, required this.userId});

  @override
  State<TeamViewActivityPatrollingList> createState() => _TeamViewActivityPatrollingListState();
}

class _TeamViewActivityPatrollingListState extends State<TeamViewActivityPatrollingList> {
  TeamViewActivityPatrollingListViewModel teamViewActivityPatrollingListViewModel = TeamViewActivityPatrollingListViewModel();
  List<Map<String, dynamic>> teamActivityPatrollingData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    checkInternetConnection();
    fetchTeamViewActivityPatrollingListData();
    super.initState();
  }

  Future<void> fetchTeamViewActivityPatrollingListData() async {
    String? token = await teamViewActivityPatrollingListViewModel.sessionManager.getToken();

    if (token != null) {
      await teamViewActivityPatrollingListViewModel.fetchTeamViewActivityPatrollingList(token, widget.userId);

      if (teamViewActivityPatrollingListViewModel.teamActivityPatrollingList != null) {
        setState(() {
          teamActivityPatrollingData = teamViewActivityPatrollingListViewModel
              .teamActivityPatrollingList!
              .map((entry) => {
            "inPhoto": entry.inPhoto,
            "dateTimeIn": entry.dateTimeIn,
            "location": entry.location,
            "checkInRemarks": entry.checkInRemarks,

          })
              .toList();
          filteredData = teamActivityPatrollingData;
        });
      }
    }
  }


  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = teamActivityPatrollingData;
      });
    } else {
      setState(() {
        filteredData = teamActivityPatrollingData.where((entry) {
          final dateTimeIn = entry['dateTimeIn']?.toLowerCase() ?? '';
          final inRemarks = entry['inRemarks']?.toLowerCase() ?? '';

          return dateTimeIn.contains(query.toLowerCase()) ||
              inRemarks.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrolling'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search Employee",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshTeamActivityPatrollingListData,
              child: filteredData.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final data = filteredData[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildColumn(
                            heading: data["dateTimeIn"],
                            imageUrl: '${AppConstants.baseUrl}/${data["inPhoto"]}',
                            //dateTime: data["dateTimeIn"],
                            borderColor: Colors.green,
                            location: data["location"],
                            headingColor: Colors.green,
                            remark: data["checkInRemarks"],
                          ),
                        ],
                      ),
                    ),
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
          ),
        ],
      ),
    );
  }

  Future<void> refreshTeamActivityPatrollingListData() async {
    await fetchTeamViewActivityPatrollingListData();
    debugPrint('Team Activity Patrolling List Data Refreshed');
  }

  Widget _buildColumn({
    required String heading,
    required String imageUrl,
    required String? location,
    required Color borderColor,
    required Color headingColor,
    required String remark,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                heading,
                style: TextStyle(
                  color: headingColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(thickness: 2, color: Colors.black26),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/place_holder.webp'),
                  )
                      : Image.asset('assets/images/place_holder.webp'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location?.split('&').first ?? 'N/A',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remark,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
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


  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("No Internet Connection"),
          content:
          const Text("Please turn on the internet connection to proceed."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
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
