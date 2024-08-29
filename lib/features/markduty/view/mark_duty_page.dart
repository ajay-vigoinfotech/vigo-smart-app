import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../widgets/in_out_btn.dart';
import '../widgets/map_page.dart';


class MarkDutyPage extends StatefulWidget {
  const MarkDutyPage({super.key});

  @override
  State<MarkDutyPage> createState() => _MarkDutyState();
}

class _MarkDutyState extends State<MarkDutyPage> {
  String _formattedDateTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime =
    DateFormat('dd-MMM-yyyy - hh:mm a').format(now);
    setState(() {
      _formattedDateTime = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Duty'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _formattedDateTime,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(child: MapPage()),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InOutBtn(btnText: 'In'),
                InOutBtn(btnText: 'Out'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}