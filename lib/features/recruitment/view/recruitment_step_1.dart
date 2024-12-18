import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:vigo_smart_app/features/recruitment/widget/custom_text_form_field.dart';
import 'package:vigo_smart_app/features/recruitment/widget/gender_radio_button.dart';

class RecruitmentStep1 extends StatefulWidget {
  const RecruitmentStep1({super.key});

  @override
  State<RecruitmentStep1> createState() => _RecruitmentStep1State();
}

class _RecruitmentStep1State extends State<RecruitmentStep1> {
  bool _expandAll = true;
  String? _selectedStatus;

  final ImagePicker _picker = ImagePicker();
  String _aadhaarImageFront = '';
  String _aadhaarImageBack = '';
  String _digitalPhoto = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  Uint8List? _signatureImageBytes;
  bool _hasSignature = false; // Initially set to false

  void _showSignatureDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sign Here'),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel_outlined, size: 30),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                height: 300,
                width: 300,
                child: SfSignaturePad(
                  key: _signaturePadKey,
                  backgroundColor: Colors.white,
                  minimumStrokeWidth: 3,
                  maximumStrokeWidth: 4,
                ),
              ),
              Text('I agree to the terms and conditions.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _hasSignature
                  ? () {
                _signaturePadKey.currentState?.clear();
                setState(() {
                  _hasSignature = false; // Disable buttons after clearing
                });
              }
                  : null, // Disable button if _hasSignature is false
              child: Text('Clear'),
            ),
            TextButton(
              onPressed: _hasSignature
                  ? () async {
                final data = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
                final bytes =
                await data.toByteData(format: ui.ImageByteFormat.png);

                if (bytes != null) {
                  setState(() {
                    _signatureImageBytes = bytes.buffer.asUint8List();
                  });
                }
                Navigator.of(context).pop();
              }
                  : null, // Disable button if _hasSignature is false
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to remove the captured signature
  void _removeSignature() {
    setState(() {
      _signatureImageBytes = null; // Reset the signature preview
    });
  }

  Future<void> _selectImage(String type) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How do you want to select image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                if (type == 'digital_photo') {
                  await _pickAndCropImage(
                      type, ImageSource.camera); // Crop for digital photo
                } else {
                  await _pickImage(
                      type, ImageSource.camera); // No crop for other types
                }
              },
            ),
            ListTile(
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                if (type == 'digital_photo') {
                  await _pickAndCropImage(
                      type, ImageSource.gallery); // Crop for digital photo
                } else {
                  await _pickImage(
                      type, ImageSource.gallery); // No crop for other types
                }
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

      final compressedImage = await FlutterImageCompress.compressWithFile(
        selectedFile.path,
        minWidth: 300, // Adjust image resolution
        minHeight: 300,
        quality: 80,
      );

      if (compressedImage != null) {
        final base64String = base64Encode(compressedImage);

        setState(() {
          if (type == 'front') {
            _aadhaarImageFront = base64String;
          } else if (type == 'back') {
            _aadhaarImageBack = base64String;
          }
        });
      }
    }
  }

  Future<void> _pickAndCropImage(String type, ImageSource source) async {
    // Pick an image using the selected source
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      // Crop the selected image
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path,
        uiSettings: [
          IOSUiSettings(
            title: 'Edit Photo',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        final File croppedImageFile = File(croppedFile.path);
        final compressedImage = await FlutterImageCompress.compressWithFile(
          croppedImageFile.path,
          minWidth: 300, // Adjust resolution
          minHeight: 300,
          quality: 80,
        );

        if (compressedImage != null) {
          final base64String = base64Encode(compressedImage);

          setState(() {
            if (type == 'digital_photo') {
              _digitalPhoto = base64String;
            }
          });
        }
      }
    }
  }

  void _deleteImage(String type) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            type == 'front'
                ? 'Are you sure you want to delete the front image?'
                : type == 'back'
                    ? 'Are you sure you want to delete the back image?'
                    : 'Are you sure you want to delete the digital photo?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      setState(() {
        if (type == 'front') {
          _aadhaarImageFront = '';
        } else if (type == 'back') {
          _aadhaarImageBack = '';
        } else if (type == 'digital_photo') {
          _digitalPhoto = '';
        }
      });
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5),
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Z0-9]')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Aadhaar Proof (Front/Back)
                          Text(
                            'Aadhaar Proof (Front/Back)',
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _selectImage('front'), // Front Image
                                    child: _aadhaarImageFront.isEmpty
                                        ? Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 50,
                                          )
                                        : Image.memory(
                                            base64Decode(_aadhaarImageFront),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _deleteImage('front'),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _selectImage('back'), // Back Image
                                    child: _aadhaarImageBack.isEmpty
                                        ? Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 50,
                                          )
                                        : Image.memory(
                                            base64Decode(_aadhaarImageBack),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _deleteImage('back'),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
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
                  title: Text('Personal Information'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            icon: Icons.person,
                            labelText: 'Name (As Per Aadhaar)',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          CustomTextFormField(
                            icon: Icons.person,
                            labelText: 'Last Name',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          CustomTextFormField(
                            icon: Icons.person,
                            labelText: "Father's Name",
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          CustomTextFormField(
                            icon: Icons.person,
                            labelText: "Mother's Name",
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          CustomTextFormField(
                            icon: Icons.person,
                            labelText: "Spouse's Name",
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          CustomTextFormField(
                            icon: Icons.call,
                            labelText: "Mobile No",
                            keyboardType: TextInputType.number,
                          ),
                          CustomTextFormField(
                            icon: Icons.calendar_month,
                            labelText: 'DOB',
                            isDatePicker: true, // Enable Date Picker
                            onChanged: (value) {
                              setState(() {
                                dateController.text = value ?? "";
                              });
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Gender *',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          GenderRadioButtons(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Marital Status',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedStatus,
                                  hint: Text('Select Marital Status',
                                      style: TextStyle(color: Colors.black54)),
                                  items: <String>[
                                    'Married',
                                    'Unmarried',
                                    'Separated',
                                    'Widow'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStatus = newValue;
                                    });
                                  },
                                  underline: SizedBox(),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Digital Photo',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _selectImage('digital_photo'),
                                child: _digitalPhoto.isEmpty
                                    ? CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 100,
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/user_camera.png',
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: 200,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 100,
                                        child: ClipOval(
                                          child: Image.memory(
                                            base64Decode(_digitalPhoto),
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: 200,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Digital Signature',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        _signatureImageBytes == null
                            ? GestureDetector(
                                onTap: _showSignatureDialog,
                                child: Text("Click here to sign",
                                    style: TextStyle(fontSize: 20)),
                              )
                            : Column(
                                children: [
                                  Image.memory(_signatureImageBytes!),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _removeSignature,
                                    child: Text("Remove Signature"),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
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
}
