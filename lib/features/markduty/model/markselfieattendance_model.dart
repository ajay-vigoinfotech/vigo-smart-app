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
  });

  // Convert the class instance to a map (JSON)
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
    };
  }
}
