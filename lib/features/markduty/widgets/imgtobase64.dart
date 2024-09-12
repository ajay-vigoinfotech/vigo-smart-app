import 'dart:convert'; // For base64 encoding
import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageToBase64 extends StatefulWidget {
  @override
  _ImageToBase64State createState() => _ImageToBase64State();
}

class _ImageToBase64State extends State<ImageToBase64> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? base64Image;

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Convert image to base64
      final bytes = await _image!.readAsBytes();
      setState(() {
        base64Image = base64Encode(bytes);
      });

      print('Base64 String: $base64Image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert Image to Base64'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!)
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            base64Image != null
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Base64 String: $base64Image',
                overflow: TextOverflow.ellipsis,
              ),
            )

                : Container(),
          ],
        ),
      ),
    );
  }
}
