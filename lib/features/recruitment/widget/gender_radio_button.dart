import 'package:flutter/material.dart';

class GenderRadioButtons extends StatefulWidget {
  final Function(int) onGenderSelected;
  final String initialGender;
  const GenderRadioButtons({
    super.key,
    required this.onGenderSelected,
    required this.initialGender,
  });

  @override
  GenderRadioButtonsState createState() => GenderRadioButtonsState();
}

class GenderRadioButtonsState extends State<GenderRadioButtons> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Set the initial gender based on the passed value
    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
                widget.onGenderSelected(1); // Send 1 for Male
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'Male';
                });
                widget.onGenderSelected(1); // Send 1 for Male
              },
              child: const Text(
                'Male',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
                widget.onGenderSelected(2); // Send 2 for Female
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'Female';
                });
                widget.onGenderSelected(2); // Send 2 for Female
              },
              child: const Text(
                'Female',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}






// import 'package:flutter/material.dart';
//
// class GenderRadioButtons extends StatefulWidget {
//   final Function(int) onGenderSelected;
//   final String? initialGender; // Accept the initial gender
//
//   const GenderRadioButtons({
//     super.key,
//     required this.onGenderSelected,
//     this.initialGender,
//   });
//
//   @override
//   GenderRadioButtonsState createState() => GenderRadioButtonsState();
// }
//
// class GenderRadioButtonsState extends State<GenderRadioButtons> {
//   String? _selectedGender;
//
//   @override
//   void didUpdateWidget(covariant GenderRadioButtons oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Update the selected gender when the parent value changes
//     if (widget.initialGender != oldWidget.initialGender) {
//       _selectedGender = widget.initialGender;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Row(
//           children: [
//             Radio<String>(
//               value: 'Male',
//               groupValue: _selectedGender,
//               onChanged: (String? value) {
//                 setState(() {
//                   _selectedGender = value;
//                   widget.onGenderSelected(1); // Send 1 for Male
//                 });
//               },
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _selectedGender = 'Male';
//                   widget.onGenderSelected(1);
//                 });
//               },
//               child: const Text(
//                 'Male',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Radio<String>(
//               value: 'Female',
//               groupValue: _selectedGender,
//               onChanged: (String? value) {
//                 setState(() {
//                   _selectedGender = value;
//                   widget.onGenderSelected(2); // Send 2 for Female
//                 });
//               },
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _selectedGender = 'Female';
//                   widget.onGenderSelected(2);
//                 });
//               },
//               child: const Text(
//                 'Female',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
