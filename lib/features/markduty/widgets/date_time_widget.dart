import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodel/get_current_date_view_model.dart';

class DateTimeWidget extends StatefulWidget {
  final GetCurrentDateViewModel getCurrentDateViewModel;

  const DateTimeWidget({super.key, required this.getCurrentDateViewModel});

  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  String timeDateDisplay = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentDateTime();
  }

  Future<void> _loadCurrentDateTime() async {
    String? currentDateTime;

    try {
      currentDateTime = await Future.any([
        widget.getCurrentDateViewModel.getTimeDate(),
        Future.delayed(const Duration(seconds: 5), () => null)
      ]);

      if (currentDateTime != null) {
        setState(() {
          timeDateDisplay = _formatDateTime(currentDateTime!);
        });
      } else {
        _setDeviceDateTime();
      }
    } catch (e) {
      debugPrint('Error fetching date from API: $e');
      _setDeviceDateTime();
    }
  }

  String _formatDateTime(String dateTime) {
    return DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(dateTime));
  }

  void _setDeviceDateTime() {
    final currentDateTime = DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.now());
    setState(() {
      timeDateDisplay = currentDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        timeDateDisplay.isEmpty ? '' : timeDateDisplay,
        style: const TextStyle(fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }
}
