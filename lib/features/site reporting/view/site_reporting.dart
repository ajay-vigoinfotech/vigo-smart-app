import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_details.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_step_2.dart';
import '../../../helper/database_helper.dart';
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

  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    loadAssignSiteList();
    fetchGetActiveSiteListData();
    super.initState();
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
            print('unitName : ${site['unitName']}');
          }
        }
        setState(() {
          uniqueAllSiteData = uniqueData;
        });
      } else {
        print('No data found in the database.');
      }
    } catch (e) {
      print('Error loading site list: $e');
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging &&
        _tabController.animation?.value == _tabController.index.toDouble()) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      fetchGetActivityQuestionsListData();
                      fetchGetAssignSitesListData();
                    },
                    child: Icon(Icons.refresh)),
              ),
            SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SiteReportingDetails()));
                  },
                  child: Icon(Icons.article_sharp)),
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
                  controller: searchController,
                  onChanged: filterSearchResults,
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
                          var site = uniqueAllSiteData[index];
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
                                          displayText: site['unitName'] ?? '',
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
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
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
          Column(
            children: [Text('Tab2')],
          ),
        ]),
      ),
    );
  }

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
}
