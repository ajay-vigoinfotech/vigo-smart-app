import 'package:flutter/material.dart';

class GenderRadioButtons extends StatefulWidget {
  const GenderRadioButtons({super.key});

  @override
  GenderRadioButtonsState createState() => GenderRadioButtonsState();
}

class GenderRadioButtonsState extends State<GenderRadioButtons> {
  String? _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Male Radio Button
        SizedBox(width: 5),
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'Male'; // Change the state when text is tapped
                });
              },
              child: const Text(
                'Male',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        // Female Radio Button
        Row(
          children: [
            Radio<String>(
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'Female'; // Change the state when text is tapped
                });
              },
              child: const Text(
                'Female',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(width: 5),

      ],
    );
  }
}
