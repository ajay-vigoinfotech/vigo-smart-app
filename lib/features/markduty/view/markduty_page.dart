import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
import '../../../core/utils.dart';
import '../../auth/session_manager/session_manager.dart';
import '../viewmodel/get_current_date_view_model.dart';

class MarkdutyPage extends StatefulWidget {
  const MarkdutyPage({super.key});

  @override
  State<MarkdutyPage> createState() => _MarkdutyPageState();
}

class _MarkdutyPageState extends State<MarkdutyPage> {
  var uuid = const Uuid();
  String? timeDateIn;
  String? timeDateOut;
  String? siteID;
  String? siteName;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentDateTime(); // Get time and date from API
    _setDeviceDateTime(); // Get time and date from current device
  }

  Future<String?> _loadCurrentDateTime() async {
    final sessionManager = SessionManager();
    final getCurrentDateViewModel = GetCurrentDateViewModel();
    String? currentDateTime;

    try {
      currentDateTime = await getCurrentDateViewModel.getTimeDate();

      if (currentDateTime != null) {
        final formattedDateTime = Utils.formatDateTime(currentDateTime);
        await sessionManager.saveCurrentDateTime(formattedDateTime);

        setState(() {
          timeDateIn = formattedDateTime;
          timeDateOut = formattedDateTime;
        });
      } else {
        currentDateTime = _setDeviceDateTime(); // Fallback to device time
      }
    } catch (e) {
      print('Error fetching date from API: $e');
      currentDateTime = _setDeviceDateTime(); // Fallback to device time
    }

    return currentDateTime;
  }

  String _setDeviceDateTime() {
    String currentDateTime =
        DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());

    setState(() {
      timeDateIn = currentDateTime;
      timeDateOut = currentDateTime;
    });

    return currentDateTime;
  }

  final SessionManager sessionManager = SessionManager();

  Future<void> _pickPunchInImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? punchInImage =
        await picker.pickImage(source: ImageSource.camera);

    if (punchInImage != null) {
      await sessionManager.savePunchInPath(punchInImage.path);
      setState(() {}); // Update state to refresh the UI
      _showImageDialog(punchInImage);
    }
  }

  Future<void> _pickPunchOutImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? punchOutImage =
        await picker.pickImage(source: ImageSource.camera);

    if (punchOutImage != null) {
      await sessionManager.savePunchOutPath(punchOutImage.path);
      setState(() {});
      _showImageDialog(punchOutImage);
    }
  }

  void _showImageDialog(XFile punchInImage) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              // Ensure the dialog is scrollable
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(punchInImage.path),
                    height: 150,
                    width: 125,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter KM'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(labelText: 'Enter Comment'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await sessionManager.savePunchInPath(punchInImage.path);
                  // print('Image path saved in Shared Preferences: ${punchInImage.path}');
                  String? savedImagePath =
                      await sessionManager.getPunchInImagePath();
                  print('Retrieved Image Path from Shared Preferences: $savedImagePath');
                  String? formattedDateTime = await _loadCurrentDateTime();
                  String generatedUuid = uuid.v4();
                  print('Unique ID: $generatedUuid');

                  if (formattedDateTime != null) {
                    print('Formatted DateTime: $formattedDateTime');
                  }
                  Navigator.pop(context, true);
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<String?>(
        future: sessionManager.getPunchInImagePath(),
        builder: (context, snapshot) {
          final imagePath = snapshot.data;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    timeDateIn ?? 'Loading...',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 300,
                width: double.infinity,
                child: MapPage(latLong: ''),
              ),
              const SizedBox(height: 20), // Space before image and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('$timeDateIn'),
                      if (imagePath != null) // Display the image for IN
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(imagePath),
                            height: 125,
                            width: 110,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: _pickPunchInImage,
                        child: const Text('IN'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // if (imagePath !=
                      //     null) // Display the image for OUT (can be different or same logic)
                      //   Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Image.file(
                      //       File(imagePath),
                      //       // Modify if OUT image logic is different
                      //       height: 100,
                      //       width: 100,
                      //     ),
                      //   ),
                      ElevatedButton(
                        onPressed: _pickPunchOutImage,
                        child: const Text('OUT'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
