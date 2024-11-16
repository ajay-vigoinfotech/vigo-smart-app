
import 'package:flutter/material.dart';

class TeamViewActivityAttendanceList extends StatefulWidget {
  const TeamViewActivityAttendanceList({super.key});

  @override
  State<TeamViewActivityAttendanceList> createState() => _TeamViewActivityAttendanceListState();
}

class _TeamViewActivityAttendanceListState extends State<TeamViewActivityAttendanceList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Name'),
      ),
    );
  }
}
