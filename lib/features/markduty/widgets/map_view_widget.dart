import 'package:flutter/material.dart';
import 'map_page.dart';

class MapViewWidget extends StatefulWidget {
  final Function(String) onLocationReceived;
  final Function(String) onSpeedReceived;
  final Function(String) onAccuracyReceived;

  const MapViewWidget({
    Key? key,
    required this.onLocationReceived,
    required this.onSpeedReceived,
    required this.onAccuracyReceived,
  }) : super(key: key);

  @override
  _MapViewWidgetState createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  String formattedLatLng = '';
  String formattedSpeedValue = '';
  String formattedAccuracyValue = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: MapPage(
        locationReceived: (location) {
          setState(() {
            formattedLatLng = location;
          });
          widget.onLocationReceived(location);
        },
        speedReceived: (speed) {
          setState(() {
            formattedSpeedValue = speed;
          });
          widget.onSpeedReceived(speed);
        },
        accuracyReceived: (accuracy) {
          setState(() {
            formattedAccuracyValue = accuracy;
          });
          widget.onAccuracyReceived(accuracy);
        },
      ),
    );
  }
}
