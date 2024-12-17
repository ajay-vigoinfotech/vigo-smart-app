import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class RecruitmentStep1 extends StatefulWidget {
  const RecruitmentStep1({super.key});

  @override
  State<RecruitmentStep1> createState() => _RecruitmentStep1State();
}

class _RecruitmentStep1State extends State<RecruitmentStep1> {
  bool _expandAll = true;


  final ImagePicker _picker = ImagePicker();
  String _aadhaarImageFront = '';
  String _aadhaarImageBack = '';

  Future<void> _selectImage(String type) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How do you want to select image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await _pickImage(type, ImageSource.camera);
              },
            ),
            ListTile(
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await _pickImage(type, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(String type, ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      final File selectedFile = File(photo.path);

      // Compress the image
      final compressedImage = await FlutterImageCompress.compressWithFile(
        selectedFile.path,
        minWidth: 100,
        minHeight: 100,
        quality: 80,
      );

      if (compressedImage != null) {
        final base64String = base64Encode(compressedImage);

        setState(() {
          if (type == 'aadhaar_front') {
            _aadhaarImageFront = base64String;
          } else if (type == 'aadhaar_back') {
            _aadhaarImageBack = base64String;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 1'),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Icons tapped');
              setState(() {
                _expandAll = !_expandAll;
              });
            },
            icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.article_sharp))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(_expandAll),
                  initiallyExpanded: _expandAll,
                  title: Row(
                    children: [
                      Text('Aadhaar Details'),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          // Aadhaar Number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: Colors.green,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  maxLength: 12,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Aadhaar No*'),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          // PAN Number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: Colors.green,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('PAN No*'),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]$';
                                    RegExp regex = RegExp(pattern);
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter PAN number';
                                    } else if (!regex.hasMatch(value)) {
                                      return 'Please enter a valid PAN number';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text('Aadhaar Proof (Front/Back)'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _selectImage('aadhaar_front'),
                                    child: Icon(Icons.add_photo_alternate_outlined, size: 50),
                                  ),

                                  GestureDetector(
                                      onTap: () {
                                        debugPrint('');
                                      },
                                      child: Text('Remove'),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _selectImage('aadhaar_back'),
                                    child: Icon(Icons.add_photo_alternate_outlined, size: 50),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        debugPrint('');
                                      },
                                      child: Text('Remove')
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.white),
                child: ExpansionTile(
                  key: ValueKey(_expandAll),
                  initiallyExpanded: _expandAll,
                  title: Text('Personal Information'),
                  children: <Widget>[
                    ListTile(title: Text('This is tile number 1')),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(_expandAll),
                  initiallyExpanded: _expandAll,
                  title: Text('Personal Documents'),
                  children: <Widget>[
                    ListTile(title: Text('This is tile number 1')),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(_expandAll),
                  initiallyExpanded: _expandAll,
                  title: Text('Deployment Details'),
                  children: <Widget>[
                    ListTile(title: Text('This is tile number 1')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(int imageNumber, File? imageFile) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(_aadhaarImageFront , _aadhaarImageBack as ImageSource),
          child: imageFile == null
              ? Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.blueGrey,
            size: 75,
          )
              : Image.file(
            imageFile,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () => _deleteImage(context, imageNumber),
          child: Text(
            'Delete',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ],
    );
  }


  void _deleteImage(BuildContext context, int imageNumber) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      setState(() {
        switch (imageNumber) {

        }
      });
    }
  }
}
