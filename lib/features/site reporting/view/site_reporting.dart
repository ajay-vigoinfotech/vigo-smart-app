import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_step_2.dart';
import '../model/get_active_site_list_model.dart';
import '../view model/get_active_site_list_view_model.dart';

class SiteReporting extends StatefulWidget {
  final String searchText;
  const SiteReporting({super.key, required this.searchText});

  @override
  State<SiteReporting> createState() => _SiteReportingState();
}

class _SiteReportingState extends State<SiteReporting>
    with SingleTickerProviderStateMixin {
  GetActiveSiteListViewModel getActiveSiteListViewModel =
      GetActiveSiteListViewModel();
  List<Map<String, dynamic>> getActiveSiteListData = [];
  List<Map<String, dynamic>> filteredData = [];

  List<GetActiveSiteListModel> getActiveSiteList = [];

  TextEditingController searchController = TextEditingController();

  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    fetchGetActiveSiteListData();
    super.initState();
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
                      debugPrint('Refresh Button tapped');
                    },
                    child: Icon(Icons.refresh)),
              ),
            SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.article_sharp),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(child: Text('ALL SITES',textAlign: TextAlign.center)),
              Tab(child: Text('SEARCH SITES', textAlign: TextAlign.center)),
              Tab(child: Text('SCHEDULE SITES', textAlign: TextAlign.center)),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          SingleChildScrollView(
            child: Column(
              children: [Text('Tab 1')],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Location - Steps 1/4',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
          filteredData = []; // Initially no data to show
        });
      } catch (error) {
        debugPrint('Error loading active site list: $error');
        setState(() {
          filteredData = []; // Reset if there is an error
        });
      }
    }
  }

  // Function to filter data based on search query
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = []; // Clear filtered data when query is empty
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
          const Icon(Icons.add_location, color: Colors.green, size: 30),
          const SizedBox(width: 1),
          Expanded(
            child: Text(
              displayText,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
