
import 'package:flutter/material.dart';

class RecruitmentStep4 extends StatefulWidget {
  final dynamic userId;

  const RecruitmentStep4({super.key, required this.userId});

  @override
  State<RecruitmentStep4> createState() => _RecruitmentStep4State();
}

class _RecruitmentStep4State extends State<RecruitmentStep4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recruitment Step 4'),
      ),
    );
  }
}
