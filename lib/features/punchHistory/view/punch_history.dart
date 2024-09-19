import 'package:flutter/material.dart';

class PunchHistory extends StatefulWidget {
  const PunchHistory({super.key});

  @override
  State<PunchHistory> createState() => _PunchHistoryState();
}

class _PunchHistoryState extends State<PunchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
    );
  }
}
