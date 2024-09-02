class MarkLoginModel {
  final String deviceDetails;
  final String punchAction;
  final String locationDetails;
  final String batteryStatus;
  final String time;
  final String latLong;
  final String version;
  final String fcmToken;
  final String dataStatus;

  MarkLoginModel({
    required this.deviceDetails,
    required this.punchAction,
    this.locationDetails = "",
    required this.batteryStatus,
    required this.time,
    this.latLong = "",
    required this.version,
    this.fcmToken = "",
    this.dataStatus = "",
  });

  Map<String, String> toMap() {
    return {
      'deviceDetails': deviceDetails,
      'punchAction': punchAction,
      'locationDetails': locationDetails,
      'batteryStatus': batteryStatus,
      'time': time,
      'latLong': latLong,
      'version': version,
      'fcmToken': fcmToken,
      'dataStatus': dataStatus,
    };
  }
}
