import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InOutBtn extends StatefulWidget {
  final String btnText;
  final dynamic btnColor;
  const InOutBtn({
    super.key,
    required this.btnText,
    this.btnColor,
  });

  @override
  _InOutBtnState createState() => _InOutBtnState();
}

class _InOutBtnState extends State<InOutBtn> {
  File? _imageFile;
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _showImageDialog();
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Captured Image..'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : const Text('No image captured.'),
                const SizedBox(height: 20),
                TextField(
                  controller: _kmController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your km',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                String km = _kmController.text;
                String comment = _commentController.text;

                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = screenWidth * 0.4;
    final buttonHeight = screenHeight * 0.1;

    final fontSize = screenWidth * 0.06;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor: widget.btnColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _pickImage,
            child: Text(
              widget.btnText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
