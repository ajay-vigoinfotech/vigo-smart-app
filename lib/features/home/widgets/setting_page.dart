import 'package:flutter/material.dart';
import 'package:vigo_smart_app/core/strings/strings.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: false,
        title: const Text(
            Strings.settingsApp,

        ),
      ),

    );
  }
}
