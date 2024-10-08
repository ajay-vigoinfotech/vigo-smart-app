import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final Function(LatLng) locationReceived;
  const MapPage({super.key, required this.locationReceived});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _googlePlex; // Make it nullable to handle uninitialized state
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  bool _isMapBeingMoved = false;
  bool _isLoading = true; // Add a loading state to indicate fetching location

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
        _showLocationError("Location permissions are denied.");
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
      print(_googlePlex);

      _setMarkerAtCurrentLocation();
      widget.locationReceived(
          _googlePlex!); // Notify MarkDutyPage with the location
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showLocationError("Failed to wget the current location of your device");
    }
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

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }


  void _checkLocationServiceStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      _showCupertinoLocationServiceDialog();
    } else if (permission == LocationPermission.denied) {
      // Handle permission denied case
      // You can show another dialog to request permission
    }
  }

  void _showCupertinoLocationServiceDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Location Service Disabled"),
        content: const Text(
          "Location services are disabled. Please enable them in your device settings to continue.",
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () {
              Geolocator.openLocationSettings(); // Open location settings directly
              Navigator.of(context).pop();
            },
            child: const Text("Open Settings"),
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
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching location
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
