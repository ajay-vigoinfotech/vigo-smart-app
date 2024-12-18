import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDatePicker;
  final void Function(String?)? onChanged;

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.isDatePicker = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  onChanged?.call(formattedDate);
                }
              }
                  : null,
              child: AbsorbPointer(
                absorbing: isDatePicker,
                child: TextFormField(
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(labelText),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
