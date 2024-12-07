import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/constants.dart';
import '../view model/previous_site_reporting_list_view_model.dart';
import '../view model/site_reporting_image_asset_view_model.dart';

class PreviousSiteReportingList extends StatefulWidget {
  final String checkinId;

  const PreviousSiteReportingList({super.key, required this.checkinId});

  @override
  State<PreviousSiteReportingList> createState() =>
      _PreviousSiteReportingListState();
}

class _PreviousSiteReportingListState extends State<PreviousSiteReportingList> {
  PreviousSiteReportingListViewModel previousSiteReportingListViewModel =
      PreviousSiteReportingListViewModel();
  SiteReportingImageAssetViewModel siteReportingImageAssetViewModel =
      SiteReportingImageAssetViewModel();

  List<Map<String, dynamic>> previousSiteReportingListData = [];
  List<Map<String, dynamic>> siteReportingImageAssetData = [];

  bool isLoading = true;


  @override
  void initState() {
    fetchPreviousSiteReportingListData();
    fetchSiteReportingImageAssetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Site Reporting List'),
      ),
      body:
      ListView.builder(
        itemCount: previousSiteReportingListData.length,
        itemBuilder: (context, index) {
          final entry = previousSiteReportingListData[index];
          final latLong = entry['latLong']?.split(',');
          final latitude = double.tryParse(latLong?[0] ?? '0') ?? 0.0;
          final longitude = double.tryParse(latLong?[1] ?? '0') ?? 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(
                      '${entry['dateTimeIn']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('marker_$index'),
                      position: LatLng(latitude, longitude),
                    ),
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Reporting Other Details',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Site Name ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${entry['clientName']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Activity Name',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${entry['checkintypename']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Remark',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${entry['inRemarks']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'All Photos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: siteReportingImageAssetData.map((data) {
                            String? imageUrl = data["userImage"] ?? data["assetImage"];
                            String label = data["userImage"] != null ? "Selfie" : "Asset Image";

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  imageUrl != null
                                      ? Image.network(
                                    '${AppConstants.baseUrl}/$imageUrl',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/place_holder.webp',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                      : Image.asset(
                                    'assets/images/place_holder.webp',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Questions List',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: [
                            ...entry['questions']
                                .asMap()
                                .entries
                                .map<Widget>((entry) {
                              final index = entry.key + 1;
                              final question = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$index. ${question['title']}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Comment : ${question['comment']}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${question['answer']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> fetchPreviousSiteReportingListData() async {
    String? token =
        await previousSiteReportingListViewModel.sessionManager.getToken();

    if (token != null) {
      await previousSiteReportingListViewModel
          .fetchPreviousSiteReportingListData(token, widget.checkinId);

      if (previousSiteReportingListViewModel.previousSiteReportingList !=
          null) {
        setState(() {
          final uniqueEntries = <String, Map<String, dynamic>>{};
          for (var entry in previousSiteReportingListViewModel
              .previousSiteReportingList!) {
            final uniqueKey =
                "${entry.latLong}_${entry.datetime}_${entry.dateTimeIn}_${entry.clientName}_${entry.checkintypename}";
            if (!uniqueEntries.containsKey(uniqueKey)) {
              uniqueEntries[uniqueKey] = {
                "latLong": entry.latLong,
                "datetime": entry.datetime,
                "dateTimeIn": entry.dateTimeIn,
                "clientName": entry.clientName,
                "checkintypename": entry.checkintypename,
                "inRemarks": entry.inRemarks,
                "questions": [
                  {
                    "title": entry.title,
                    "answer": entry.answer,
                    "comment": entry.comment,
                  }
                ],
              };
            } else {
              uniqueEntries[uniqueKey]?["questions"].add({
                "title": entry.title,
                "answer": entry.answer,
                "comment": entry.comment,
              });
            }
          }
          previousSiteReportingListData = uniqueEntries.values.toList();
        });
      }
    }
  }

  Future<void> fetchSiteReportingImageAssetData() async {
    String? token =
        await siteReportingImageAssetViewModel.sessionManager.getToken();

    if (token != null) {
      await siteReportingImageAssetViewModel.fetchSiteReportingImageAssetData(
          token, widget.checkinId);

      if (siteReportingImageAssetViewModel.siteReportingImageAssetList !=
          null) {
        setState(() {
          // Extract userImage only once and keep all assetImage entries
          final userImage = siteReportingImageAssetViewModel
              .siteReportingImageAssetList!.first.userImage;

          siteReportingImageAssetData = [
            {"userImage": userImage}, // Include userImage first
            ...siteReportingImageAssetViewModel.siteReportingImageAssetList!
                .map((entry) => {"assetImage": entry.assetImage}),
          ];
        });
      }
    }
  }
}
