import 'package:flutter/material.dart';

class PreviousSiteReportingList extends StatefulWidget {
  final String checkinId;

  const PreviousSiteReportingList({super.key, required this.checkinId});

  @override
  State<PreviousSiteReportingList> createState() =>
      _PreviousSiteReportingListState();
}

class _PreviousSiteReportingListState extends State<PreviousSiteReportingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Site Reporting List'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
