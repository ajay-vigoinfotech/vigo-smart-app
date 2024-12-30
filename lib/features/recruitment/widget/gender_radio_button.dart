import 'package:flutter/material.dart';

class GenderRadioButtons extends StatefulWidget {
  final Function(int) onGenderSelected;

  const GenderRadioButtons({super.key, required this.onGenderSelected});

  @override
  GenderRadioButtonsState createState() => GenderRadioButtonsState();
}

class GenderRadioButtonsState extends State<GenderRadioButtons> {
  String? _selectedGender = '';

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
                  widget.onGenderSelected(1); // Send 1 for Male
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'Male';
                  widget.onGenderSelected(1);
                });
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
                  widget.onGenderSelected(2);
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGender = 'Female';
                  widget.onGenderSelected(2); // Send 2 for Female
                });
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
