import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng _googlePlex = const LatLng(19.2059, 72.8500);
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  bool _isMapBeingMoved = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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

    if (permission == LocationPermission.deniedForever) {
      _showLocationError("Location permissions are permanently denied.");
      return;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _googlePlex = LatLng(position.latitude, position.longitude);

      _moveCameraToLocation();
      _setMarkerAtCurrentLocation();
    } catch (e) {
      _showLocationError("Failed to get current location of your device");
    }
  }

  void _moveCameraToLocation() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 14,
          target: _googlePlex,
        ),
      ),
    );
  }

  void _setMarkerAtCurrentLocation() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId("Current Location"),
        position: _googlePlex,
      ),
    );
    setState(() {});
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _googlePlex,
          zoom: 14,
        ),
        onCameraMove: (CameraPosition position) {
          _isMapBeingMoved = true;
        },
        onCameraIdle: () {
          if (_isMapBeingMoved) {
            Future.delayed(const Duration(seconds: 1), () {
              _moveCameraToLocation();
              _isMapBeingMoved = false;
            });
          }
        },
      ),
    );
  }
}
