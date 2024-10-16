class PunchDetails {
  String deviceDetails;
  String deviceImei;
  String deviceIp;
  String userPhoto;
  String remark;
  String isOffline;
  String version;
  String dataStatus;
  String checkInId;
  String punchAction;
  String locationAccuracy;
  String locationSpeed;
  String batteryStatus;
  String locationStatus;
  String time;
  String latLong;
  String kmsDriven;
  String siteId;
  String locationId;
  String distance;

  PunchDetails({
    required this.deviceDetails,
    required this.deviceImei,
    required this.deviceIp,
    required this.userPhoto,
    required this.remark,
    required this.isOffline,
    required this.version,
    required this.dataStatus,
    required this.checkInId,
    required this.punchAction,
    required this.locationAccuracy,
    required this.locationSpeed,
    required this.batteryStatus,
    required this.locationStatus,
    required this.time,
    required this.latLong,
    required this.kmsDriven,
    required this.siteId,
    required this.locationId,
    required this.distance,
  });

  // Convert the class instance to a map (JSON)
  Map<String, String> toJson() {
    return {
      'deviceDetails': deviceDetails,
      'deviceImei': deviceImei,
      'deviceIp': deviceIp,
      'userPhoto': userPhoto,
      'remark': remark,
      'isOffline': isOffline,
      'version': version,
      'dataStatus': dataStatus,
      'checkInId': checkInId,
      'punchAction': punchAction,
      'locationAccuracy': locationAccuracy,
      'locationSpeed': locationSpeed,
      'batteryStatus': batteryStatus,
      'locationStatus': locationStatus,
      'time': time,
      'latLong': latLong,
      'kmsDriven': kmsDriven,
      'siteId': siteId,
      'locationId': locationId,
      'distance': distance,
    };
  }
}
