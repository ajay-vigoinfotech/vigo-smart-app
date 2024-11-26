import 'package:flutter/material.dart';
import '../view model/get_active_site_list_view_model.dart';

class SiteReporting extends StatefulWidget {
  final String searchText;
  const SiteReporting({super.key, required this.searchText});

  @override
  State<SiteReporting> createState() => _SiteReportingState();
}

class _SiteReportingState extends State<SiteReporting> {
  GetActiveSiteListViewModel getActiveSiteListViewModel = GetActiveSiteListViewModel();
  List<Map<String, dynamic>> getActiveSiteListData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  late TabController _tabController;
  @override
  void initState() {
    fetchGetActiveSiteListData();
    super.initState();
  }

  Future<void> fetchGetActiveSiteListData() async {
    String? token = await getActiveSiteListViewModel.sessionManager.getToken();
    if (token != null) {
      await getActiveSiteListViewModel.fetchGetActiveSiteList(
          token, widget.searchText);
      if (getActiveSiteListViewModel.getActiveSiteList != null) {
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
          filteredData = getActiveSiteListData;
        });
      }
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = getActiveSiteListData;
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
          bottom: TabBar(
            tabs: [
              Tab(child: Text('ALL SITES')),
              Tab(
                  child: Text(
                'SEARCH SITES',
                textAlign: TextAlign.center,
              )),
              Tab(
                  child: Text(
                'SCHEDULE SITES',
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
        body: TabBarView(
            children: [
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
                  Expanded(
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
                                _buildCardColumn(displayText: data['text']),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text('No results found.'),
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

  Widget _buildCardColumn({
    required String displayText,
  }) {
    return Expanded(
        child: Container(
      child: Row(
        children: [
          Icon(Icons.location_on),
          Text(displayText),
        ],
      ),
    ));
  }
}
