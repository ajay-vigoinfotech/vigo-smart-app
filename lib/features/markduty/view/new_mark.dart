import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../core/theme/app_pallete.dart';
import '../widgets/map_page.dart';

class MarkDutyPage extends StatefulWidget {
  const MarkDutyPage({super.key});

  @override
  State<MarkDutyPage> createState() => _MarkDutyState();
}

class _MarkDutyState extends State<MarkDutyPage> {
  String _formattedDateTime = '';
  Timer? _timer;
  bool isDutyIn = false; // Tracks duty status

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer t) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(now);
    });
  }

  // Function to handle "In" or "Out" duty status
  void _handleMarkDuty(bool isIn) {
    String action = isIn ? 'In' : 'Out';
    setState(() {
      isDutyIn = isIn;
    });

    // Add your API call or local storage interaction here
    // Example:
    print('Marked duty $action at $_formattedDateTime');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked duty $action at $_formattedDateTime'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: const Text('Mark Duty'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _formattedDateTime,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Pallete.dark,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 300,
              width: double.infinity,
              child: MapPage(latLong: ''),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _handleMarkDuty(true); // Mark "In"
                  },
                  child: const Text('In'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleMarkDuty(false); // Mark "Out"
                  },
                  child: const Text('Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
