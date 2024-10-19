class CheckSessionModel {
  String? fcmToken;
  String? appVersion;

  CheckSessionModel({
    required this.fcmToken,
    required this.appVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      'fcmToken': fcmToken,
      'appVersion': appVersion,
    };
  }
}
