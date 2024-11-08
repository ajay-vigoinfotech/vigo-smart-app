import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';

class MapPage extends StatefulWidget {
  final Function(String)locationReceived;
  final Function(String) speedReceived;
  final Function(String)accuracyReceived;
  const MapPage({
    super.key,
    required this.locationReceived,
    required this.speedReceived,
    required this.accuracyReceived,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _googlePlex; // Make it nullable to handle uninitialized state
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  bool _isMapBeingMoved = false;
  bool _isLoading = true;
  bool _locationDialog = false;

  @override
  void initState() {
    super.initState();
    _checkLocationServiceStatus();
    _checkLocationService();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showCupertinoLocationServiceDialog();
        //_showLocationError("Location permissions are denied.");
        return;
      }
    }
    _getCurrentLocation();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showCupertinoLocationServiceDialog();
      return;
    }
    _checkLocationPermission();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      _googlePlex = LatLng(position.latitude, position.longitude);

      _setMarkerAtCurrentLocation();
      widget.locationReceived(_formatLatLng(_googlePlex!));
      widget.speedReceived(_formatSpeed(position.speed));
      widget.accuracyReceived(_formatAccuracy(position.accuracy));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showCupertinoAppSettingsDialog();
      //_showLocationError("Failed to get the current location of your device");
    }
  }

  String _formatLatLng(LatLng latLng) {
    return "${latLng.latitude.toStringAsFixed(7)},${latLng.longitude.toStringAsFixed(7)}";
  }

  String _formatSpeed(double speed) {
    return speed.toStringAsFixed(2);
  }

  String _formatAccuracy(double accuracy) {
    return accuracy.toStringAsFixed(2);
  }

  void _moveCameraToLocation() {
    if (_googlePlex != null) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 15,
            target: _googlePlex!,
          ),
        ),
      );
    }
  }

  void _setMarkerAtCurrentLocation() {
    _markers.clear();
    if (_googlePlex != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("Current Location"),
          position: _googlePlex!,
        ),
      );
      setState(() {});
    }
  }


  void _checkLocationServiceStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      _showCupertinoLocationServiceDialog();
    } else if (permission == LocationPermission.denied) {}
  }

  void _showCupertinoLocationServiceDialog() {
    if(_locationDialog) {
      return;
    }
    _locationDialog = true;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Location Service Disabled"),
        content: const Text(
          "Please enable in your device settings to continue.",
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () {
              _locationDialog = false;
              switch (OpenSettingsPlus.shared) {
                case OpenSettingsPlusAndroid settings:
                  settings.locationSource();
                  break;
                case OpenSettingsPlusIOS settings:
                  settings.locationServices();
                  break;
                default:
                  throw Exception('Platform not supported');
              }
              Navigator.of(context).pop();
            },
            child: const Text("Open Location Services"),
          ),
        ],
      ),
    );
  }

  void _showCupertinoAppSettingsDialog() {
    if(_locationDialog) {
      return;
    }
    _locationDialog = true;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Location Permission Disabled"),
        content: const Text(
          "Please enable in your app settings to continue.",
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () {
              _locationDialog = false;
              switch (OpenSettingsPlus.shared) {
                case OpenSettingsPlusAndroid settings:
                  settings.locationSource();
                  break;
                case OpenSettingsPlusIOS settings:
                  settings.appSettings();
                  break;
                default:
                  throw Exception('Platform not supported');
              }
              Navigator.of(context).pop();
            },
            child: const Text("Open App Settings"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show loading indicator while fetching location
          : GoogleMap(
              myLocationButtonEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
                _moveCameraToLocation(); // Move the camera once the map is created
              },
              initialCameraPosition: CameraPosition(
                target: _googlePlex!, // Use the current location once fetched
                zoom: 16,
              ),
              onCameraMove: (CameraPosition position) {
                _isMapBeingMoved = true;
              },
              onCameraIdle: () {
                if (_isMapBeingMoved) {
                  Future.delayed(const Duration(seconds: 2), () {
                    _moveCameraToLocation();
                    _isMapBeingMoved = false;
                  });
                }
              },
            ),
    );
  }
}
