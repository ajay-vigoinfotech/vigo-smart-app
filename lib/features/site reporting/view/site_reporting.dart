import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/site%20reporting/view%20model/get_schedule_site_list_view_model.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_details.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_step_2.dart';
import '../../../helper/database_helper.dart';
import '../../home/view/home_page.dart';
import '../model/get_active_site_list_model.dart';
import '../view model/get_active_site_list_view_model.dart';
import '../view model/get_activity_questions_list_app_view_model.dart';
import '../view model/get_assign_site_list_view_model.dart';

class SiteReporting extends StatefulWidget {
  final String searchText;
  const SiteReporting({super.key, required this.searchText});

  @override
  State<SiteReporting> createState() => _SiteReportingState();
}

class _SiteReportingState extends State<SiteReporting>
    with SingleTickerProviderStateMixin {
  //Get Assign Site List
  GetAssignSitesListViewModel getAssignSitesListViewModel =
      GetAssignSitesListViewModel();
  List<Map<String, dynamic>> getAssignSitesListData = [];
  List<Map<String, dynamic>> uniqueAllSiteData = [];

  GetActiveSiteListViewModel getActiveSiteListViewModel =
      GetActiveSiteListViewModel();
  GetActivityQuestionsListAppViewModel getActivityQuestionsListAppViewModel =
      GetActivityQuestionsListAppViewModel();

  List<Map<String, dynamic>> getActiveSiteListData = [];
  List<Map<String, dynamic>> getActivityQuestionsListData = [];
  List<Map<String, dynamic>> filteredData = [];
  List<GetActiveSiteListModel> getActiveSiteList = [];

  TextEditingController allSiteSearchController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  //Get Schedule Site
  DateTime selectedDate = DateTime.now();

  // String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  GetScheduleSiteListViewModel getScheduleSiteListViewModel =
      GetScheduleSiteListViewModel();
  List<Map<String, dynamic>> getScheduleSiteListData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _checkInternetConnection();
    loadAssignSiteList();
    fetchGetActiveSiteListData();
    fetchScheduleSIteByUserID();
    fetchGetAssignSitesListData();
  }

  Future<void> fetchGetActivityQuestionsListData() async {
    String? token =
        await getActivityQuestionsListAppViewModel.sessionManager.getToken();
    if (token != null) {
      await getActivityQuestionsListAppViewModel
          .fetchGetActivityQuestionsList(token);
      if (getActivityQuestionsListAppViewModel.getActivityQuestionsListCount !=
          null) {
        setState(() {
          getActivityQuestionsListData = getActivityQuestionsListAppViewModel
              .getActivityQuestionsListCount!
              .map((entry) => {
                    "activityId": entry.activityId,
                    "activityName": entry.activityName,
                    "questionId": entry.questionId,
                    "questionName": entry.questionName,
                  })
              .toList();
        });
        // Save data to SQLite
        DatabaseHelper dbHelper = DatabaseHelper();
        await dbHelper.insertActivityQuestions(getActivityQuestionsListData);
      }
    }
  }

  Future<void> fetchGetAssignSitesListData() async {
    String? token = await getAssignSitesListViewModel.sessionManager.getToken();

    if (token != null) {
      await getAssignSitesListViewModel.fetchGetAssignSitesListData(token);
      if (getAssignSitesListViewModel.getAssignSitesList != null) {
        setState(() {
          getAssignSitesListData =
              getAssignSitesListViewModel.getAssignSitesList!
                  .map((entry) => {
                        'siteId': entry.siteId,
                        'compID': entry.compID,
                        'clientId': entry.clientId,
                        'siteName': entry.siteName,
                        'siteCode': entry.siteCode,
                        'unitName': entry.unitName,
                        'clientName': entry.clientName,
                      })
                  .toList();
        });
        DatabaseHelper dbHelper = DatabaseHelper();
        await dbHelper.insertAssignSiteList(getAssignSitesListData);
      }
    }
  }

  Future<void> loadAssignSiteList() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    try {
      List<Map<String, dynamic>> data = await dbHelper.fetchAllAssignSite();

      if (data.isNotEmpty) {
        final Set<int> uniqueSiteIds = {};
        final List<Map<String, dynamic>> uniqueData = [];

        for (var site in data) {
          if (!uniqueSiteIds.contains(site['siteId'])) {
            uniqueSiteIds.add(site['siteId']);
            uniqueData.add(site);
            // print('Unique Site: $site');
            // print('siteId : ${site['siteId']}');
            // print('unitName : ${site['unitName']}');
          }
        }
        setState(() {
          uniqueAllSiteData = uniqueData;
        });
      } else {
        debugPrint('No data found in the database.');
      }
    } catch (e) {
      debugPrint('Error loading site list: $e');
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging &&
        _tabController.animation?.value == _tabController.index.toDouble()) {
      setState(() {});
    }
  }

  void filterAllSiteSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        uniqueAllSiteData = List<Map<String, dynamic>>.from(uniqueAllSiteData);
      });
    } else {
      setState(() {
        uniqueAllSiteData = getAssignSitesListData.where((site) {
          final siteId = site['siteId']?.toLowerCase() ?? '';
          final compID = site['compID']?.toLowerCase() ?? '';
          final clientId = site['clientId']?.toLowerCase() ?? '';
          final siteName = site['siteName']?.toLowerCase() ?? '';
          final siteCode = site['siteCode']?.toLowerCase() ?? '';
          final unitName = site['unitName']?.toLowerCase() ?? '';
          final clientName = site['clientName']?.toLowerCase() ?? '';

          return siteId.contains(query.toLowerCase()) ||
              compID.contains(query.toLowerCase()) ||
              clientId.contains(query.toLowerCase()) ||
              siteName.contains(query.toLowerCase()) ||
              unitName.contains(query.toLowerCase()) ||
              clientName.contains(query.toLowerCase()) ||
              siteCode.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Site Reporting',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          actions: [
            if (_tabController.index == 0)
              IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  CircularProgressIndicator();
                  // debugPrint('refresh!!');
                  Fluttertoast.showToast(
                    msg: "Data Refresh SuccessFully.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  fetchGetActivityQuestionsListData();
                  fetchGetAssignSitesListData();
                },
              ),
            IconButton(
              icon: Icon(Icons.article_sharp),
              tooltip: 'View Details',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SiteReportingDetails()),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(child: Text('ALL SITES', textAlign: TextAlign.center)),
              Tab(child: Text('SEARCH SITES', textAlign: TextAlign.center)),
              Tab(child: Text('SCHEDULE SITES', textAlign: TextAlign.center)),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Location - Steps 1/4',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: allSiteSearchController,
                  onChanged: filterAllSiteSearchResults,
                  decoration: InputDecoration(
                    hintText: "Search here offline",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Sites: ${uniqueAllSiteData.length}',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              uniqueAllSiteData.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: uniqueAllSiteData.length,
                        itemBuilder: (context, index) {
                          var allSite = uniqueAllSiteData[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SiteReportingStep2(
                                      siteId: uniqueAllSiteData[index]
                                          ['siteId'],
                                      value: '',
                                      text: '',
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildCardColumn(
                                          displayText:
                                              allSite['unitName'] ?? '',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(child: Text('No Data')),
            ],
          ),

          //Tab 2 starts here
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Location - Steps 1/4',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
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
              if (searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Sites: ${filteredData.length}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: searchController.text.isEmpty
                    ? Center(
                        child: Text(
                          'Please start typing to search..',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : filteredData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off,
                                    size: 64, color: Colors.black),
                                const SizedBox(height: 16),
                                const Text(
                                  'No Data Found!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final data = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SiteReportingStep2(
                                        value: filteredData[index]['value'],
                                        text: filteredData[index]['text'],
                                        siteId: '',
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildCardColumn(
                                              displayText: data['text'] ?? ''),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),

          //Tab 3 starts here
          Column(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.green),
                ),
                child: EasyDateTimeLinePicker(
                  selectionMode: SelectionMode.none(),
                  headerOptions: HeaderOptions(
                    headerType: HeaderType.viewOnly, // default
                  ),
                  timelineOptions: TimelineOptions(
                    height: 100,
                  ),
                  firstDate: DateTime.now().subtract(const Duration(days: 183)),
                  lastDate: DateTime.now().add(const Duration(days: 183)),
                  focusedDate: selectedDate,
                  onDateChange: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                    });
                    fetchScheduleSIteByUserID();
                  },
                ),
              ),
              getScheduleSiteListData.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: getScheduleSiteListData.length,
                        itemBuilder: (context, index) {
                          var schedule = getScheduleSiteListData[index];
                          bool isActive = schedule['isActive'] == "1";

                          if (schedule['scheduleDate'] !=
                              DateFormat('yyyy-MM-dd').format(selectedDate)) {
                            return SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: GestureDetector(
                              onTap: isActive
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SiteReportingStep2(
                                            siteId: schedule['siteId'],
                                            value: '',
                                            text: '',
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Stack(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Date: ${schedule['scheduleDate']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Status: ${schedule['statusText']}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: isActive
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Site Name',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '${schedule['unitName']}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Created By',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '${schedule['createdBy']}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Remark',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  '${schedule['remarks']}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 4,
                                        color: Colors.green,
                                      ),
                                    ),
                                  if (!isActive)
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 4,
                                        color: Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                          // child: CircularProgressIndicator(),
                          ),
                    ),
            ],
          ),
        ]),
      ),
    );
  }

  Future<void> fetchScheduleSIteByUserID() async {
    String? token =
        await getScheduleSiteListViewModel.sessionManager.getToken();
    if (token != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      await getScheduleSiteListViewModel.fetchGetScheduleSiteListData(
          token, formattedDate);

      if (getScheduleSiteListViewModel.getScheduleSiteList != null) {
        setState(() {
          getScheduleSiteListData =
              getScheduleSiteListViewModel.getScheduleSiteList!
                  .map((entry) => {
                        'siteId': entry.siteId,
                        'remarks': entry.remarks,
                        'scheduleDate': entry.scheduleDate,
                        'scheduleDate1': entry.scheduleDate1,
                        'statusText': entry.statusText,
                        'unitName': entry.unitName,
                        'createdBy': entry.createdBy,
                        'isActive': entry.isActive,
                      })
                  .toList();
        });
      } else {
        // Handle case where getScheduleSiteList is null
        print('getScheduleSiteList is null');
      }
    } else {
      // Handle case where token is null
      print('Token is null');
    }
  }

  // Future<void> fetchScheduleSIteByUserID() async {
  //   String? token =
  //       await getScheduleSiteListViewModel.sessionManager.getToken();
  //   if (token != null) {
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  //
  //     await getScheduleSiteListViewModel.fetchGetScheduleSiteListData(
  //         token, formattedDate);
  //
  //     setState(() {
  //       getScheduleSiteListData =
  //           getScheduleSiteListViewModel.getScheduleSiteList!
  //               .map((entry) => {
  //                     'siteId': entry.siteId,
  //                     'remarks': entry.remarks,
  //                     'scheduleDate': entry.scheduleDate,
  //                     'scheduleDate1': entry.scheduleDate1,
  //                     'statusText': entry.statusText,
  //                     'unitName': entry.unitName,
  //                     'createdBy': entry.createdBy,
  //                     'isActive': entry.isActive,
  //                   })
  //               .toList();
  //     });
  //   }
  // }

  // Function to fetch data from API
  Future<void> fetchGetActiveSiteListData() async {
    String? token = await getActiveSiteListViewModel.sessionManager.getToken();
    if (token != null) {
      try {
        await getActiveSiteListViewModel.fetchGetActiveSiteList(
            token, widget.searchText);
        setState(() {
          getActiveSiteListData = getActiveSiteListViewModel.getActiveSiteList!
              .map((entry) => {
                    'value': entry.value,
                    'text': entry.text,
                    'address': entry.address,
                    'zone': entry.zone,
                    'strength': entry.strength,
                  })
              .toList();
          filteredData = [];
        });
      } catch (error) {
        debugPrint('Error loading active site list: $error');
        setState(() {
          filteredData = [];
        });
      }
    }
  }

  // Function to filter data based on search query
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = [];
      });
    } else {
      setState(() {
        filteredData = getActiveSiteListData.where((entry) {
          final value = entry['value']?.toLowerCase() ?? '';
          final text = entry['text']?.toLowerCase() ?? '';
          final address = entry['address']?.toLowerCase() ?? '';
          final zone = entry['zone']?.toLowerCase() ?? '';
          final strength = entry['strength']?.toLowerCase() ?? '';

          return value.contains(query.toLowerCase()) ||
              text.contains(query.toLowerCase()) ||
              address.contains(query.toLowerCase()) ||
              zone.contains(query.toLowerCase()) ||
              strength.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Widget _buildCardColumn({
    required String displayText,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          const Icon(Icons.add_location, color: Colors.green, size: 30),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              displayText,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              softWrap: true,
              maxLines: 5,
            ),
          ),
          const SizedBox(width: 1),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 18,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
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
}
