import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDatePicker;
  final void Function(String?)? onChanged;
  final TextEditingController? controller; // Added controller for better control

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.isDatePicker = false,
    this.onChanged,
    this.controller, // Accepting controller
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Expanded(
            child: GestureDetector(
              onTap: isDatePicker
                  ? () async {
                // Open Date Picker if isDatePicker is true
                final DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (selectedDate != null) {
                  final formattedDate =
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  onChanged?.call(formattedDate); // Pass formatted date
                }
              }
                  : null,
              child: AbsorbPointer(
                absorbing: isDatePicker, // Absorbs input while date picker is active
                child: TextFormField(
                  controller: controller, // Use the controller if provided
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: labelText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: onChanged, // Keeps other changes working
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
