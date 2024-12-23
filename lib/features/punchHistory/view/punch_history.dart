import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../home/view/home_page.dart';
import '../viewmodel/getselfieattendance_view_model.dart';

class PunchHistory extends StatefulWidget {
  const PunchHistory({super.key});

  @override
  State<PunchHistory> createState() => _PunchHistoryState();
}

class _PunchHistoryState extends State<PunchHistory> {
  GetSelfieAttendanceViewModel getSelfieAttendanceViewModel =
      GetSelfieAttendanceViewModel();
  List<Map<String, dynamic>> getSelfieAttendanceData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    _checkInternetConnection();
    fetchGetSelfieAttendanceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
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
                    onRefresh: refreshGetSelfieAttendanceData,
                    child: filteredData.isEmpty
                        ? Center(
                            child: Text('No Data Available'),
                          )
                        : ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildColumn(
                                          heading: 'Check In',
                                          imageUrl:
                                              '${AppConstants.baseUrl}/${data["inPhoto"]}',
                                          dateTime: data["dateTimeIn"],
                                          borderColor: Colors.green,
                                          location: data["location"],
                                          headingColor: Colors.green,
                                          remark: data["inRemarks"]),
                                      const VerticalDivider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        width: 10,
                                      ),
                                      _buildColumn(
                                          heading: 'Check Out',
                                          imageUrl:
                                              '${AppConstants.baseUrl}/${data["outPhoto"]}',
                                          dateTime: data["dateTimeOut"],
                                          borderColor: Colors.redAccent,
                                          location: data["outLocation"],
                                          headingColor: Colors.redAccent,
                                          remark: data["outRemarks"],
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

  Future<void> refreshGetSelfieAttendanceData() async {
    await fetchGetSelfieAttendanceData();
    debugPrint('Get SelfieAttendance Data Refreshed');
  }

  Widget _buildColumn({
    required String heading,
    required String imageUrl,
    required String? dateTime,
    required String? location,
    required Color borderColor,
    required Color headingColor,
    required String? remark,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyle(
                color: headingColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(thickness: 2, color: Colors.black26),
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
            const SizedBox(height: 8),
            Text(
              (dateTime ?? '').isNotEmpty ? dateTime! : 'Not marked yet',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              location?.split('&').first ?? 'N/A',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 4),
            Text(
              remark!,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkInternetConnection() async {
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
              onPressed: () => Navigator.pushAndRemoveUntil(
                this.context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              ),
              // Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> fetchGetSelfieAttendanceData() async {
    String? token =
        await getSelfieAttendanceViewModel.sessionManager.getToken();

    if (token != null) {
      await getSelfieAttendanceViewModel.fetchGetSelfieAttendanceList(token);

      if (getSelfieAttendanceViewModel.getSelfieAttendanceList != null) {
        setState(() {
          getSelfieAttendanceData =
              getSelfieAttendanceViewModel.getSelfieAttendanceList!
                  .map((entry) => {
                        "compId": entry.compId,
                        "dateTimeIn": entry.dateTimeIn,
                        "dateTimeOut": entry.dateTimeOut,
                        "totalHours": entry.totalHours,
                        "location": entry.location,
                        "outLocation": entry.outLocation,
                        "inRemarks": entry.inRemarks,
                        "inPhoto": entry.inPhoto,
                        "outPhoto": entry.outPhoto,
                        "outRemarks": entry.outRemarks,
                        "inKmsDriven": entry.inKmsDriven,
                        "outKmsDriven": entry.outKmsDriven,
                      })
                  .toList();
          filteredData = getSelfieAttendanceData;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = getSelfieAttendanceData;
      });
    } else {
      setState(() {
        filteredData = getSelfieAttendanceData.where((entry) {
          final dateTimeIn = entry['dateTimeIn']?.toLowerCase() ?? '';
          final dateTimeOut = entry['dateTimeOut']?.toLowerCase() ?? '';
          final inRemarks = entry['inRemarks']?.toLowerCase() ?? '';
          final outRemarks = entry['outRemarks']?.toLowerCase() ?? '';

          return dateTimeIn.contains(query.toLowerCase()) ||
              dateTimeOut.contains(query.toLowerCase()) ||
              inRemarks.contains(query.toLowerCase()) ||
              outRemarks.contains(query.toLowerCase());
        }).toList();
      });
    }
  }
}
