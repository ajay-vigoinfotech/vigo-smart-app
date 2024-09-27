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
  var uuid = const Uuid(); // generate V4 Unique ID
  String? timeDateIn;
  String? timeDateOut;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentDateTime(); //get Time Date from API
    _setDeviceDateTime(); //get Time Date from Current Device
  }

  Future<String?> _loadCurrentDateTime() async {
    final sessionManager = SessionManager();
    final getCurrentDateViewModel = GetCurrentDateViewModel();
    String? currentDateTime;

    try {
      // Fetch current date from the API
      currentDateTime = await getCurrentDateViewModel.getTimeDate();

      if (currentDateTime != null) {
        // Format and save the date from the API
        final formattedDateTime = Utils.formatDateTime(currentDateTime);
        await sessionManager.saveCurrentDateTime(formattedDateTime);

        setState(() {
          timeDateIn = formattedDateTime;
          timeDateOut = formattedDateTime;
        });
      } else {
        // If API returns null, fallback to device time
        currentDateTime = _setDeviceDateTime();
      }
    } catch (e) {
      // In case of error, fallback to device time
      currentDateTime = _setDeviceDateTime();
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

  Future<void> _pickPunchInImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {});
      _showImageDialog(pickedFile);
    }
  }

  Future<void> _pickPunchOutImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {});
      _showImageDialog(pickedFile);
    }
  }

  void _showImageDialog(XFile pickedFile) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: const Text(''),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  File(pickedFile.path),
                  height: 150,
                  width: 125,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _kmController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _commentController,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Call the function to get the formatted date and time
                  String? formattedDateTime = await _loadCurrentDateTime();

                  // Generate a unique ID
                  String generatedUuid = uuid.v4();
                  print('Unique ID: $generatedUuid');

                  // Ensure the formatted date is used
                  if (formattedDateTime != null) {
                    // Use the formatted date and generated UUID
                    print('Formatted DateTime: $formattedDateTime');

                    // You can now use `formattedDateTime` for further operations
                    // Example: Send to an API, display on the screen, etc.
                  }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Text(
                timeDateIn ??
                    'Loading...', // Display the timeDateIn or loading text
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 300,
            width: double.infinity,
            child: MapPage(latLong: ''),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _pickPunchInImage,
                  child: const Text('IN'),
                ),
              ),
              ElevatedButton(
                onPressed: _pickPunchOutImage,
                child: const Text('OUT'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
