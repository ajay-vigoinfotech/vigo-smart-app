import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../core/theme/app_pallete.dart';
import '../widgets/map_page.dart';

class MarkDutyPage extends StatefulWidget {
  const MarkDutyPage({super.key});

  @override
  State<MarkDutyPage> createState() => _MarkDutyState();
}

class _MarkDutyState extends State<MarkDutyPage> {
  String _formattedDateTime = '';
  String? _markInTime; // Stores mark-in time
  String? _markOutTime; // Stores mark-out time
  Timer? _timer;
  File? _inImage; // Stores image for mark-in
  File? _outImage; // Stores image for mark-out
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;
  bool _hasSubmittedIn = false;
  bool _hasSubmittedOut = false;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    });
  }

  Future<void> _pickImage(bool isIn) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(
        () {
          if (isIn) {
            _inImage = File(pickedFile.path);
            _markInTime =
                _formattedDateTime; // Update mark-in time on image capture
            _hasCheckedIn = true; // Update checked-in status
          } else {
            _outImage = File(pickedFile.path);
            _markOutTime =
                _formattedDateTime; // Update mark-out time on image capture
            _hasCheckedOut = true; // Update checked-out status
          }
        },
      );
      _showImageDialog(isIn); // Show dialog after capturing the image
    }
  }

  void _showImageDialog(bool isIn) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: AlertDialog(
              title: const Text('Preview Image'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isIn
                      ? _inImage != null
                          ? Image.file(
                              _inImage!,
                              height: 150,
                              width: 125,
                              fit: BoxFit.cover,
                            )
                          : const Text('No Image Captured')
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
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        if (isIn) {
                          _hasSubmittedIn = true;
                        } else {
                          _hasSubmittedOut = true;
                        }
                      },
                    );
                    Navigator.of(context)
                        .pop(); // Close the dialog after submission
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show an alert dialog
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: const Text('Mark Duty'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _formattedDateTime,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Pallete.dark,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 300,
              width: double.infinity,
              child: MapPage(latLong: ''),
            ),
            const SizedBox(height: 20),

            // Row for In and Out buttons with image previews and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Column for "In" button, image preview, and time
                Column(
                  children: [
                    if (_hasCheckedIn && _hasSubmittedIn)
                      Column(
                        children: [
                          _inImage != null
                              ? Image.file(
                                  _inImage!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Text(
                            _markInTime ?? 'No In Time Available',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 75,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_hasCheckedIn) {
                            _showAlertDialog('Duty in already');
                          } else {
                            _pickImage(true); // Capture image for "In"
                          }
                        },
                        child: const Text(
                          'In',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                // Column for "Out" button, image preview, and time
                Column(
                  children: [
                    if (_hasCheckedOut && _hasSubmittedOut)
                      Column(
                        children: [
                          _outImage != null
                              ? Image.file(
                                  _outImage!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Text(
                            _markOutTime ?? 'No Out Time Available',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 75,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _hasCheckedIn
                            ? () {
                                if (_hasCheckedOut) {
                                  _showAlertDialog('Duty out already');
                                } else {
                                  _pickImage(false); // Capture image for "Out"
                                }
                              }
                            : () {
                                _showAlertDialog('Please Punch In First');
                              },
                        child: const Text(
                          'Out',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
