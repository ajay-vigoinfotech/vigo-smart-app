import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';
import 'package:vigo_smart_app/features/markduty/widgets/date_time_widget.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../markduty/viewmodel/get_current_date_view_model.dart';

class FieldReporting extends StatefulWidget {
  const FieldReporting({super.key});

  @override
  State<FieldReporting> createState() => _FieldReportingState();
}

class _FieldReportingState extends State<FieldReporting> {
  final getCurrentDateViewModel = GetCurrentDateViewModel();

  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';

  // Build the MapView with dynamic height
  Widget _buildMapView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      child: MapPage(
        locationReceived: _onLocationReceived,
        speedReceived: _onSpeedReceived,
        accuracyReceived: _onAccuracyReceived,
      ),
    );
  }

  // Location Callback
  void _onLocationReceived(String formattedLocation) {
    setState(() {
      formattedLatLng = formattedLocation;
    });
  }

  // Speed Callback
  void _onSpeedReceived(String formattedSpeed) {
    setState(() {
      formattedSpeedValue = formattedSpeed;
    });
  }

  // Accuracy Callback
  void _onAccuracyReceived(String formattedAccuracy) {
    setState(() {
      formattedAccuracyValue = formattedAccuracy;
    });
  }

  Future<void> onInButtonPressed() async{
    final ImagePicker picker = ImagePicker();
    final XFile? patrollingImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 1,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.fieldReportingApp),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('MARK PATROLLING')),
              Tab(child: Text('PUNCH HISTORY')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // MARK PATROLLING Tab Content
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: DateTimeWidget(
                      getCurrentDateViewModel: getCurrentDateViewModel,
                    ),
                  ),
                  _buildMapView(),
                  const SizedBox(height: 180),
                  SizedBox(
                    height: 70,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                        onPressed: onInButtonPressed,
                        child: const Text(
                          'IN',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                    ),
                  ),
                ],
              ),
            ),
            // PUNCH HISTORY Tab Content
            const Center(
              child: Text('2nd Tab'),
            ),
          ],
        ),
      ),
    );
  }

}
