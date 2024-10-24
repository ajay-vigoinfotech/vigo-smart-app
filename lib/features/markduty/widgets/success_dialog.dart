import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onOkayPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onOkayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.green)),
        ],
      ),
      content: Text(message),
      actions: [
        Center(
          child: TextButton(
            onPressed: onOkayPressed,
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }
}

void showSuccessDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SuccessDialog(
        title: title,
        message: message,
        onOkayPressed: () {
          Navigator.of(context).pop(); // Close the dialog
        },
      );
    },
  );
}
