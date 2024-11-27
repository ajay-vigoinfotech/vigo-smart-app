import 'package:flutter/material.dart';

class SiteReportingStep2 extends StatefulWidget {
  const SiteReportingStep2({super.key, required value});

  @override
  State<SiteReportingStep2> createState() => _SiteReportingStep2State();
}

class _SiteReportingStep2State extends State<SiteReportingStep2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step 2'),
      ),
    );
  }
}
