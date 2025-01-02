import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDatePicker;
  final bool isStatePicker;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onTap; // Add this for handling taps

  final int? maxLength;
  final Color? iconColor;
  final bool? enabled;

  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.isDatePicker = false,
    this.isStatePicker = false,
    this.onChanged,
    this.controller,
    this.maxLength,
    this.iconColor,
    this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
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
                            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                        onChanged?.call(formattedDate);
                      }
                    }
                  : null,
              child: AbsorbPointer(
                absorbing: isDatePicker,
                child: TextFormField(
                  maxLength: maxLength,
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: labelText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: onChanged,
                  enabled: enabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
