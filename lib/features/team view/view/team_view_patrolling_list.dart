import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigo_smart_app/features/team%20view/view%20model/team_view_patrolling_list_view_model.dart';

class TeamViewPatrollingList extends StatefulWidget {
  const TeamViewPatrollingList({super.key});

  @override
  State<TeamViewPatrollingList> createState() => _TeamViewPatrollingListState();
}

class _TeamViewPatrollingListState extends State<TeamViewPatrollingList> {
  TeamViewPatrollingListViewModel teamViewPatrollingListViewModel =
      TeamViewPatrollingListViewModel();
  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedState = 'All';
  final List<String> stateOptions = ["All", "Done", "Not Done"];

  List<Map<String, dynamic>> patrollingData = [];
  List<Map<String, dynamic>> filteredPatrollingData = [];

  String? fullName;
  int? counts;
  String? status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrolling List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 5),
                  Text(
                    selectedDate,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              DropdownButton<String>(
                  value: selectedState,
                  items: stateOptions.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (newState) {
                    setState(() {
                      selectedState = newState!;
                    });
                  }),
              TextButton(
                  onPressed: fetchPatrollingListData,
                  child: const Text('Search'))
            ],
          ),
          const SizedBox(height: 2),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Sr",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                Expanded(
                    flex: 5,
                    child: Text("Employee Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                Expanded(
                    flex: 3,
                    child: Text("Count",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                Expanded(
                    flex: 2, // Reduced flex for Status
                    child: Text("Status",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatrollingData.length,
              itemBuilder: (context, index) {
                final data = filteredPatrollingData[index];
                return SizedBox(
                  height: 70,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: Text("${index + 1}")),
                          Expanded(
                            flex: 6,
                            child: Text(
                              "${data['fullName'] ?? "N/A"}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          // Expanded(
                          //     flex: 3, child: Text(data['counts'] ?? "N/A")),
                          Expanded(
                            flex: 1,
                            child: Text(
                              data['status'] ?? "N/A",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: data['status'] == "Present"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> fetchPatrollingListData() async {
    String? token =
        await teamViewPatrollingListViewModel.sessionManager.getToken();
    if (token != null) {
      await teamViewPatrollingListViewModel.fetchPatrollingList(token);
      if (teamViewPatrollingListViewModel.patrollingList != null) {
        setState(() {
          patrollingData = teamViewPatrollingListViewModel.patrollingList!
              .map((entry) => {
                    "fullName": entry.fullName,
                    "counts": entry.counts,
                    "status": entry.status,
                  })
              .toList();
          applyFilter();
        });
      }
    }
  }

  void applyFilter() {
    setState(() {
      if (selectedState == "All") {
        filteredPatrollingData = patrollingData;
      } else if (selectedState == "Done") {
        filteredPatrollingData = patrollingData.where((entry) => entry['status'] == 'Done').toList();
      } else if (selectedState == "Not Done") {
        filteredPatrollingData = patrollingData
            .where((entry) => entry['status'] == 'Not Done')
            .toList();
      }
    });
  }
}

// fullName = teamViewPatrollingListViewModel.patrollingList![0].fullName;
// counts = teamViewPatrollingListViewModel.patrollingList![0].counts;
// status = teamViewPatrollingListViewModel.patrollingList![0].status;
