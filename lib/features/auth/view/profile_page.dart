import 'package:flutter/material.dart';
import '../session_manager/session_manager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();
    setState(() {
      _accessToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child:
            Text('Token: $_accessToken'),
      ),
    );
  }
}
