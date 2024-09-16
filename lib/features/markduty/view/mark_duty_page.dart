import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../core/theme/app_pallete.dart';
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
      _formattedDateTime = DateFormat('dd-MMM-yyyy hh:mm a').format(now);
    });
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
          children: <Widget>[
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
              child: MapPage(),
            ),
            const SizedBox(height: 50),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InOutBtn(
                  btnText: 'IN',
                  btnColor: Colors.green,
                ),
                InOutBtn(
                  btnText: "OUT",
                  btnColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
