class MarkFieldReportingModel {
  String? deviceDetails;
  String? deviceImei;
  String? deviceIp;
  String? userPhoto;
  String? remark;
  String? isOffline;
  String? version;
  String? dataStatus;
  String? checkInId;
  String? punchAction;
  String? locationAccuracy;
  String? locationSpeed;
  String? batteryStatus;
  String? locationStatus;
  String? time;
  String? latLong;
  String? kmsDriven;
  String? siteId;
  String? locationId;
  String? distance;

  MarkFieldReportingModel({
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

  // Factory constructor for deserialization from JSON
  factory MarkFieldReportingModel.fromJson(Map<String, dynamic> json) {
    return MarkFieldReportingModel(
      deviceDetails: json['deviceDetails'].toString(),
      deviceImei: json['deviceImei'].toString(),
      deviceIp: json['deviceIp'].toString(),
      userPhoto: json['userPhoto'].toString(),
      remark: json['remark'].toString(),
      isOffline: json['isOffline'].toString(),
      version: json['version'].toString(),
      dataStatus: json['dataStatus'].toString(),
      checkInId: json['checkInId'].toString(),
      punchAction: json['punchAction'].toString(),
      locationAccuracy: json['locationAccuracy'].toString(),
      locationSpeed: json['locationSpeed'].toString(),
      batteryStatus: json['batteryStatus'].toString(),
      locationStatus: json['locationStatus'].toString(),
      time: json['time'].toString(),
      latLong: json['latLong'].toString(),
      kmsDriven: json['kmsDriven'].toString(),
      siteId: json['siteId'].toString(),
      locationId: json['locationId'].toString(),
      distance: json['distance'].toString(),
    );
  }

  // Method for serialization to JSON
  Map<String, dynamic> toJson() {
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
