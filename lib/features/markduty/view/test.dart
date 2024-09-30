// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';
// import 'package:vigo_smart_app/features/markduty/widgets/map_page.dart';
// import '../../../core/utils.dart';
// import '../../auth/session_manager/session_manager.dart';
// import '../viewmodel/get_current_date_view_model.dart';
//
// class MarkdutyPage extends StatefulWidget {
//   const MarkdutyPage({super.key});
//
//   @override
//   State<MarkdutyPage> createState() => _MarkdutyPageState();
// }
//
// class _MarkdutyPageState extends State<MarkdutyPage> {
//   String? uniqueId; // Store unique ID generated during Punch In
//   String? timeDateIn;
//   String? timeDateOut;
//   String siteId = ''; // Example Site ID
//   String siteName = ''; // Example Site Name
//
//   final TextEditingController _inKmController = TextEditingController();
//   final TextEditingController _outKmController = TextEditingController();
//   final TextEditingController _commentController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentDateTime(); //get Time Date from API
//     _setDeviceDateTime(); //get Time Date from Current Device
//   }
//
//   Future<String?> _loadCurrentDateTime() async {
//     final sessionManager = SessionManager();
//     final getCurrentDateViewModel = GetCurrentDateViewModel();
//     String? currentDateTime;
//
//     try {
//       currentDateTime = await getCurrentDateViewModel.getTimeDate();
//       if (currentDateTime != null) {
//         final formattedDateTime = Utils.formatDateTime(currentDateTime);
//         await sessionManager.saveCurrentDateTime(formattedDateTime);
//         setState(() {
//           timeDateIn = formattedDateTime;
//           timeDateOut = formattedDateTime;
//         });
//       } else {
//         currentDateTime = _setDeviceDateTime();
//       }
//     } catch (e) {
//       currentDateTime = _setDeviceDateTime();
//     }
//     return currentDateTime;
//   }
//
//   String _setDeviceDateTime() {
//     String currentDateTime =
//     DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.now());
//     setState(() {
//       timeDateIn = currentDateTime;
//       timeDateOut = currentDateTime;
//     });
//     return currentDateTime;
//   }
//
//   Future<void> _pickPunchInImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile =
//     await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         // uniqueId = Uuid().v4();
//       });
//       _showImageDialog(pickedFile, isPunchIn: true);
//     }
//   }
//
//   Future<void> _pickPunchOutImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile =
//     await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {});
//       _showImageDialog(pickedFile, isPunchIn: false);
//     }
//   }
//
//   void _showImageDialog(XFile pickedFile, {required bool isPunchIn}) async {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.file(
//                   File(pickedFile.path),
//                   height: 150,
//                   width: 125,
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: isPunchIn ? _inKmController : _outKmController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: isPunchIn
//                         ? 'Enter IN Kms Driven'
//                         : 'Enter OUT Kms Driven',
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _commentController,
//                   decoration: const InputDecoration(labelText: 'Comment'),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 },
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   String? formattedDateTime = await _loadCurrentDateTime();
//
//                   // Use Punch In or Punch Out logic accordingly
//                   if (isPunchIn) {
//                     timeDateIn = formattedDateTime;
//                   } else {
//                     timeDateOut = formattedDateTime;
//                   }
//
//                   if (formattedDateTime != null) {
//                     // If Punch In, save relevant data
//                     if (isPunchIn) {
//                       print('Punch In UUID: $uniqueId');
//                       print('Punch In Time: $timeDateIn');
//                       print('IN Kms: ${_inKmController.text}');
//                       print('IN Comment $_commentController');
//                     } else {
//                       // For Punch Out, use the same UUID generated during Punch In
//                       print('Punch Out UUID: $uniqueId');
//                       print('Punch Out Time: $timeDateOut');
//                       print('OUT Kms: ${_outKmController.text}');
//                       _savePunchData();
//                     }
//                   }
//
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           );
//         });
//   }
//
//   // Save Punch In and Punch Out data
//   void _savePunchData() {
//     final punchData = {
//       'uniqueId': uniqueId,
//       'dateTimeIn': timeDateIn,
//       'dateTimeOut': timeDateOut,
//       'inKmsDriven': _inKmController.text,
//       'outKmsDriven': _outKmController.text,
//       'siteId': siteId,
//       'siteName': siteName,
//     };
//
//     // You can save this punch data to a database or backend here
//     print('Punch Data: $punchData');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: Center(
//               child: Text(
//                 timeDateIn ?? 'Loading...',
//                 style:
//                 const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 300,
//             width: double.infinity,
//             child: MapPage(latLong: ''),
//           ),
//           const SizedBox(height: 50),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _pickPunchInImage();
//                   uniqueId = const Uuid().v4();
//                   print('Unique ID: $uniqueId');
//                 },
//                 child: const Text('IN'),
//               ),
//             ),
//           ]),
//           ElevatedButton(
//             onPressed: () {
//               _pickPunchOutImage();
//               uniqueId = const Uuid().v4();
//               print('Unique ID: $uniqueId');
//             },
//             child: const Text('OUT'),
//           ),
//         ],
//       ),
//     );
//   }
// }
