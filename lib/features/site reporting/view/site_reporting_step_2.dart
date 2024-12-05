import 'package:flutter/material.dart';
import 'package:vigo_smart_app/features/site%20reporting/view/site_reporting_step_3.dart';
import '../../../helper/database_helper.dart';

class SiteReportingStep2 extends StatefulWidget {
  const SiteReportingStep2(
      {super.key,
      required this.value,
      required this.text,
      required this.siteId});

  final dynamic value;
  final dynamic text;
  final dynamic siteId;

  @override
  State<SiteReportingStep2> createState() => _SiteReportingStep2State();
}

class _SiteReportingStep2State extends State<SiteReportingStep2> {
  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  Future<void> _loadDataFromDatabase() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> data = await dbHelper.fetchAllQuestions();

    // Use a map to filter unique activities based on `activityId`
    final uniqueActivities = <int, Map<String, dynamic>>{};
    for (var entry in data) {
      uniqueActivities[entry['activityId']] = {
        'activityId': entry['activityId'],
        'activityName': entry['activityName'],
      };
    }

    setState(() {
      _questions = data;
      _activities = uniqueActivities.values.toList();
    });

    debugPrint('Loaded questions: $data');
    debugPrint('Unique activities: $_activities');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Reporting'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select Activity - Steps 2/4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
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
              child: _activities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final activity = _activities[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SiteReportingStep3(
                                      activityId: activity['activityId'],
                                      activityName: activity['activityName'],
                                      questions: _questions,
                                      value: widget.value,
                                      text: widget.text,
                                      siteId: widget.siteId),
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
                                            activity['activityName'] ?? '',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardColumn({required String displayText}) {
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
