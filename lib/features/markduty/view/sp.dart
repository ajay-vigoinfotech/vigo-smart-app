// // ... imports ...
//
// class MarkdutyPage extends StatefulWidget {
//   // ...
// }
//
// class _MarkdutyPageState extends State<MarkdutyPage> {
//   // ... variables ...
//
//   final _markdutyViewModel = MarkdutyViewModel(); // Create a view model
//
//   @override
//   void initState() {
//     super.initState();
//     _markdutyViewModel.loadCurrentDateTime(); // Initialize in view model
//   }
//
//   Future<void> _pickPunchImage(PunchType type) async {//     // ... image picking logic ...
//     if (pickedFile != null) {
//       _markdutyViewModel.setImagePath(type,pickedFile.path); // Store in view model
//       _showImageDialog(type, pickedFile);
//     }
//   }
//
//   void _showImageDialog(PunchType type, XFile pickedFile) async {
//     // ... dialog logic ...
//     TextButton(
//       onPressed: () async {
//         // ... get data from text fields ...
//         _markdutyViewModel.submitData(type, imagePath, km, comment); // Submit in view model
//         Navigator.pop(context, true);
//       },
//       child: const Text('Submit'),
//     ),
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // ... UI ...
//       ElevatedButton(
//         onPressed: () => _pickPunchImage(PunchType.in), // Pass punch type
//         child: const Text('IN'),
//       ),
//       ElevatedButton(
//         onPressed: () => _pickPunchImage(PunchType.out), // Pass punch type
//         child: const Text('OUT'),
//       ),
//       // ...
//     );
//   }
// }
//
// // Enum for punch type
// enum PunchType { in, out }
//
// // MarkdutyViewModel (Illustrative)
// class MarkdutyViewModel {
//   // ... variables for image paths, date/time, etc. ...
//
//   Future<void> loadCurrentDateTime() async {
//     // ... logic to fetch and set date/time ...
//   }
//
//   void setImagePath(PunchType type, String path) {
//     // ... store image path based on punch type ...
//   }
//
//   Future<void> submitData(PunchType type, String imagePath, String km, String comment) async {
//     // ... logic to submit data ...
//   }
// }