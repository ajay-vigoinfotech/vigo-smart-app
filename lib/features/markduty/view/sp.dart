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
//   var uuid = const Uuid();
//   String? timeDateIn;
//   String? timeDateOut;
//   bool isPunchInDone = false;
//   bool isPunchOutDone = false;
//   final TextEditingController _commentController = TextEditingController();
//   final TextEditingController _kmController = TextEditingController();
//
//   final SessionManager sessionManager = SessionManager();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentDateTime();
//     _setDeviceDateTime();
//     _loadPunchStatus();
//   }
//
//   // Load punch status from SessionManager (if user already punched IN/OUT)
//   Future<void> _loadPunchStatus() async {
//     isPunchInDone = await sessionManager.isPunchInDone() ?? false;
//     isPunchOutDone = await sessionManager.isPunchOutDone() ?? false;
//     setState(() {});
//   }
//
//   Future<String?> _loadCurrentDateTime() async {
//     final getCurrentDateViewModel = GetCurrentDateViewModel();
//     String? currentDateTime;
//
//     try {
//       currentDateTime = await getCurrentDateViewModel.getTimeDate();
//
//       if (currentDateTime != null) {
//         final formattedDateTime = Utils.formatDateTime(currentDateTime);
//         await sessionManager.saveCurrentDateTime(formattedDateTime);
//
//         setState(() {
//           timeDateIn = formattedDateTime;
//           timeDateOut = formattedDateTime;
//         });
//       } else {
//         currentDateTime = _setDeviceDateTime(); // Fallback to device time
//       }
//     } catch (e) {
//       print('Error fetching date from API: $e');
//       currentDateTime = _setDeviceDateTime(); // Fallback to device time
//     }
//
//     return currentDateTime;
//   }
//
//   String _setDeviceDateTime() {
//     String currentDateTime =
//     DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
//
//     setState(() {
//       timeDateIn = currentDateTime;
//       timeDateOut = currentDateTime;
//     });
//
//     return currentDateTime;
//   }
//
//   // Pick and display Punch-In image
//   Future<void> _pickPunchInImage() async {
//     if (isPunchInDone && !isPunchOutDone) {
//       // Validation: Don't allow IN again if OUT is not done yet
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Punch OUT must be done before Punch IN again.")),
//       );
//       return;
//     }
//
//     final ImagePicker picker = ImagePicker();
//     final XFile? punchInImage =
//     await picker.pickImage(source: ImageSource.camera);
//
//     if (punchInImage != null) {
//       // Show the dialog and handle its outcome
//       _showPunchInImageDialog(punchInImage, true);
//     }
//   }
//
//   // Pick and display Punch-Out image
//   Future<void> _pickPunchOutImage() async {
//     if (!isPunchInDone) {
//       // Validation: Allow OUT only if IN is done
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please Punch IN first.")),
//       );
//       return;
//     }
//     if (isPunchOutDone) {
//       // Validation: Don't allow OUT again if already done
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Punch OUT already done.")),
//       );
//       return;
//     }
//
//     final ImagePicker picker = ImagePicker();
//     final XFile? punchOutImage =
//     await picker.pickImage(source: ImageSource.camera);
//
//     if (punchOutImage != null) {
//       _showPunchOutImageDialog(punchOutImage, true);
//     }
//   }
//
//   void _showPunchInImageDialog(XFile punchInImage, bool isPunchIn) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.file(
//                   File(punchInImage.path),
//                   height: 150,
//                   width: 125,
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _kmController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Enter KM'),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _commentController,
//                   decoration: const InputDecoration(labelText: 'Enter Comment'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   // Ensure punchInImage is not null and has a valid path
//                   if (punchInImage.path.isNotEmpty) {
//                     // Save Punch-In image path
//                     await sessionManager.savePunchInPath(punchInImage.path);
//
//                     // Get the current date and time and save it
//                     String currentDateTime = _setDeviceDateTime();
//                     await sessionManager.savePunchInTime(currentDateTime);
//
//                     // Set Punch-In done status to true
//                     await sessionManager.setPunchInDone(true);
//
//                     // Update state
//                     setState(() {
//                       isPunchInDone = true;
//                       isPunchOutDone = false;
//                       timeDateIn = currentDateTime; // Update timeDateIn
//                       timeDateOut =
//                           currentDateTime; // Optionally update timeDateOut
//                     });
//
//                     // Navigate back
//                     Navigator.pop(context, true);
//                   } else {
//                     // Handle invalid punch-in image path
//                     print("Punch-in image path is invalid");
//                   }
//                 } catch (e) {
//                   // Handle any errors
//                   print("Error in Punch-In: $e");
//                 }
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showPunchOutImageDialog(XFile punchOutImage, bool isPunchOut) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.file(
//                   File(punchOutImage.path),
//                   height: 150,
//                   width: 125,
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _kmController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Enter KM'),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _commentController,
//                   decoration: const InputDecoration(labelText: 'Enter Comment'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Save Punch-Out data and update the status
//                 await sessionManager.savePunchOutPath(punchOutImage.path);
//                 await sessionManager.savePunchOutTime(_setDeviceDateTime());
//                 setState(() {
//                   isPunchOutDone = true;
//                 });
//                 await sessionManager.setPunchOutDone(true);
//
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: FutureBuilder<String?>(
//         future: sessionManager.getPunchInImagePath(),
//         builder: (context, punchInSnapshot) {
//           final punchInImagePath = punchInSnapshot.data;
//
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Center(
//                   child: Text(
//                     timeDateIn ?? 'Loading..',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 250,
//                 width: double.infinity,
//                 child: MapPage(latLong: ''),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(
//                     children: [
//                       Text('$timeDateIn'),
//                       if (punchInImagePath != null)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.file(
//                             File(punchInImagePath),
//                             height: 125,
//                             width: 110,
//                           ),
//                         ),
//                       SizedBox(
//                         height: 80,
//                         width: 120,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             elevation: 5,
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onPressed: _pickPunchInImage,
//                           child: const Text(
//                             'IN',
//                             style: TextStyle(
//                               fontSize: 30,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text('$timeDateOut'),
//                       SizedBox(
//                         height: 80,
//                         width: 120,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             elevation: 5,
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onPressed: _pickPunchOutImage,
//                           child: const Text(
//                             'OUT',
//                             style: TextStyle(
//                               fontSize: 30,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
