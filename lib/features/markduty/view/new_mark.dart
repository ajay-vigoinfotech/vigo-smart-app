import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../viewmodel/get_current_date_view_model.dart';
import '../widgets/map_page.dart';

class MarkdutyPage extends StatefulWidget {
  const MarkdutyPage({super.key});

  @override
  _MarkdutyPageState createState() => _MarkdutyPageState();
}

class _MarkdutyPageState extends State<MarkdutyPage> {
  String? timeDateDisplay;
  String? timeDateIn;
  String? timeDateOut;
  File? _inImage;
  File? _outImage;
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;

  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Duty'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                '$timeDateDisplay',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 275,
            width: double.infinity,
            child: MapPage(locationReceived: _onLocationReceived),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _hasCheckedIn
                    ? null
                    : () async {
                        _pickPunchImage(true);
                        debugPrint('Punch IN');
                        // Handle IN button click
                        setState(() {
                          _hasCheckedIn = true;
                          _hasCheckedOut = false;
                        });
                      },
                child: const Text('IN'),
              ),
              ElevatedButton(
                onPressed: (!_hasCheckedIn || _hasCheckedOut)
                    ? null
                    : () async {
                        _pickPunchImage(false);
                        debugPrint('Punch OUT');
                        // Handle OUT button click
                        setState(() {
                          _hasCheckedOut = true;
                          _hasCheckedIn = false;
                        });
                      },
                child: const Text('OUT'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadCurrentDateTime() async {
    final sessionManager = SessionManager();
    final getCurrentDateViewModel = GetCurrentDateViewModel();
    String? currentDateTime;

    try {
      currentDateTime = await getCurrentDateViewModel.getTimeDate();
      if (currentDateTime != null) {
        final formattedDateTime = Utils.formatDateTime(currentDateTime);
        await sessionManager.saveCurrentDateTime(formattedDateTime);

        setState(() {
          timeDateDisplay = formattedDateTime;
          timeDateIn = formattedDateTime;
          timeDateOut = formattedDateTime;
        });
      } else {
        currentDateTime = _setDeviceDateTime(); // Fallback to device time
      }
    } catch (e) {
      debugPrint('Error fetching date from API: $e');
      currentDateTime = _setDeviceDateTime(); // Fallback to device time
    }
  }

  String _setDeviceDateTime() {
    String currentDateTime =
        DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
    setState(() {
      timeDateDisplay = currentDateTime;
      timeDateIn = currentDateTime;
      timeDateOut = currentDateTime;
    });
    return currentDateTime;
  }

  void _onLocationReceived(LatLng latLng) {
    debugPrint("Location received: $latLng"); // Print the received LatLng
    setState(() {
      _hasCheckedIn = false; // Enable the IN button
    });
  }

  Future<void> _pickPunchImage(bool isIn) async {
    final ImagePicker picker = ImagePicker();
    final XFile? punchImage =
        await picker.pickImage(source: ImageSource.camera);

    if (punchImage != null) {
      setState(() {
        if (isIn) {
          _inImage = File(punchImage.path);
          _hasCheckedIn = true;
        } else {
          _outImage = File(punchImage.path);
          _hasCheckedOut = true;
        }
      });
      _showImageDialog(isIn);
    }
  }

  void _showImageDialog(bool isIn) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isIn
                      ? _inImage != null
                          ? Image.file(
                              _inImage!,
                              height: 150,
                              width: 125,
                            )
                          : const Text('No image captured')
                      : _outImage != null
                          ? Image.file(
                              _outImage!,
                              height: 150,
                              width: 125,
                              fit: BoxFit.cover,
                            )
                          : const Text('No Image Captured'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _kmController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Start KM '),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Comment'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  debugPrint('Punch In done');
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }
}
