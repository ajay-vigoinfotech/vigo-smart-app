// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
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
//   String? timeDateDisplay;
//   List<String> timeStamps = []; // List to store timestamps
//   final picker = ImagePicker();
//   final SessionManager sessionManager = SessionManager();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentDateTime(); // Initial load of date and time
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mark Duty'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               _captureTimeStamp();
//             },
//             child: const Text('Capture Time Stamp'),
//           ),
//           Text("$timeDateDisplay", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
//           Expanded(
//             flex: 10,
//             child: ListView.builder(
//               itemCount: timeStamps.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//
//                   title: Center(child: Text(timeStamps[index])),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _loadCurrentDateTime() async {
//     final sessionManager = SessionManager();
//     final getCurrentDateViewModel = GetCurrentDateViewModel();
//     String? currentDateTime;
//     try {
//       // Fetch current date and time from the API
//       currentDateTime = await getCurrentDateViewModel.getTimeDate();
//       if (currentDateTime != null) {
//         final formattedDateTime = Utils.formatDateTime(currentDateTime);
//         await sessionManager.saveCurrentDateTime(formattedDateTime); // Save to SP
//         setState(() {
//           timeDateDisplay = formattedDateTime; // Update display
//         });
//       } else {
//         currentDateTime = _setDeviceDateTime(); // Fallback to device time
//       }
//     } catch (e) {
//       currentDateTime = _setDeviceDateTime(); // Handle error
//     }
//   }
//
//   String _setDeviceDateTime() {
//     String currentDateTime =
//     DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
//     setState(() {
//       timeDateDisplay = currentDateTime;
//     });
//     return currentDateTime;
//   }
//
//   Future<void> _captureTimeStamp() async {
//     await _loadCurrentDateTime(); // Get the latest date and time from API
//     await _loadCurrentDateTime();
//     if (timeDateDisplay != null) {
//       setState(() {
//         timeStamps.add(timeDateDisplay!); // Add the fetched time to the list
//       });
//     }
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
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
//   LatLng? currentLocation;
//   String? timeDateDisplay;
//   String? punchIn;
//   String? punchOut;
//   final picker = ImagePicker();
//   final SessionManager sessionManager = SessionManager();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentDateTime(); // Initial load of date and time
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Mark Duty'),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Center(child: Text('$timeDateDisplay'),),
//             ),
//             const SizedBox(height: 5),
//             SizedBox(
//               height: 264,
//               width: double.infinity,
//               child: MapPage(locationReceived: _onLocationReceived),
//             ),
//             const SizedBox(height: 5),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     ElevatedButton(onPressed: () {
//
//                     },
//                         child: const Text('IN')),
//                   ],
//                 ),
//
//                 Column(
//                   children: [
//                     ElevatedButton(onPressed: () {},
//                         child: const Text('OUT')),
//                   ],
//                 ),
//
//               ],
//             )
//
//           ],
//         )
//     );
//   }
//
//   Future<void> _loadCurrentDateTime() async {
//     final sessionManager = SessionManager();
//     final getCurrentDateViewModel = GetCurrentDateViewModel();
//     String? currentDateTime;
//     try {
//       // Fetch current date and time from the API
//       currentDateTime = await getCurrentDateViewModel.getTimeDate();
//       if (currentDateTime != null) {
//         final formattedDateTime = Utils.formatDateTime(currentDateTime);
//         await sessionManager.saveCurrentDateTime(formattedDateTime);
//         setState(() {
//           timeDateDisplay = formattedDateTime;
//         });
//       } else {
//         currentDateTime = _setDeviceDateTime();
//       }
//     } catch (e) {
//       currentDateTime = _setDeviceDateTime();
//     }
//   }
//
//   String _setDeviceDateTime() {
//     String currentDateTime =
//     DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now());
//     setState(() {
//       timeDateDisplay = currentDateTime;
//     });
//     return currentDateTime;
//   }
//
//   void _onLocationReceived(LatLng latLng) {
//     setState(() {
//       currentLocation = latLng;
//     });
//   }
//
//   void _captureTimeStampIn() async {
//     await _loadCurrentDateTime();
//     if (timeDateDisplay != null) {
//       setState(() {
//         punchIn = timeDateDisplay;
//       });
//     }
//   }
//
//   void _captureTimeStampOut() async {
//     await _loadCurrentDateTime();
//     if (timeDateDisplay != null) {
//       setState(() {
//         punchOut = timeDateDisplay;
//       });
//     }
//   }
// }

