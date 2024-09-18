import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");
      return token;
    } catch (e) {
      print("Failed to get FCM token: $e");
      return null;
    }
  }
}
