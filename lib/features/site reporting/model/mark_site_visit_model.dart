class MarkSiteVisitModel {
  String? clientSiteId;
  String? checkListRes;
  String? deviceDetails;
  String? deviceImei;
  String? deviceIp;
  String? siteName;
  String? checkInTypeid;
  String? locationID;
  String? equipment;
  String? scheduleDate;
  String? isOffline;
  String? version;
  String? locationName;
  String? assetImg;
  String? checkListComments;
  String? checkListQuesId;
  String? userImage;
  String? batteryStatus;
  String? locationDetails;
  String? time;
  String? activityId;
  String? latLong;
  String? remarks;
  String? dataUsage;

  MarkSiteVisitModel({
    required this.clientSiteId,
    required this.checkListRes,
    required this.deviceDetails,
    required this.deviceImei,
    required this.deviceIp,
    required this.siteName,
    required this.checkInTypeid,
    required this.locationID,
    required this.equipment,
    required this.scheduleDate,
    required this.isOffline,
    required this.version,
    required this.locationName,
    required this.assetImg,
    required this.checkListComments,
    required this.checkListQuesId,
    required this.userImage,
    required this.batteryStatus,
    required this.locationDetails,
    required this.time,
    required this.activityId,
    required this.latLong,
    required this.remarks,
    required this.dataUsage,
  });

  factory MarkSiteVisitModel.fromJson(Map<String, dynamic> json) {
    return MarkSiteVisitModel(
      clientSiteId: json['clientSiteId'].toString(),
      checkListRes: json['checkListRes'].toString(),
      deviceDetails: json['deviceDetails'].toString(),
      deviceImei: json['deviceImei'].toString(),
      deviceIp: json['deviceIp'].toString(),
      siteName: json['siteName'].toString(),
      checkInTypeid: json['checkInTypeid'].toString(),
      locationID: json['locationID'].toString(),
      equipment: json['equipment'].toString(),
      scheduleDate: json['scheduleDate'].toString(),
      isOffline: json['isOffline'].toString(),
      version: json['version'].toString(),
      locationName: json['locationName'].toString(),
      assetImg: json['assetImg'].toString(),
      checkListComments: json['checkListComments'].toString(),
      checkListQuesId: json['checkListQuesId'].toString(),
      userImage: json['userImage'].toString(),
      batteryStatus: json['batteryStatus'].toString(),
      locationDetails: json['locationDetails'].toString(),
      time: json['time'].toString(),
      activityId: json['activityId'].toString(),
      latLong: json['latLong'].toString(),
      remarks: json['remarks'].toString(),
      dataUsage: json['dataUsage'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientSiteId': clientSiteId,
      'checkListRes': checkListRes,
      'deviceDetails': deviceDetails,
      'deviceImei': deviceImei,
      'deviceIp': deviceIp,
      'siteName': siteName,
      'checkInTypeid': checkInTypeid,
      'locationID': locationID,
      'equipment': equipment,
      'scheduleDate': scheduleDate,
      'isOffline': isOffline,
      'version': version,
      'locationName': locationName,
      'assetImg': assetImg,
      'checkListComments': checkListComments,
      'checkListQuesId': checkListQuesId,
      'userImage': userImage,
      'batteryStatus': batteryStatus,
      'locationDetails': locationDetails,
      'time': time,
      'activityId': activityId,
      'latLong': latLong,
      'remarks': remarks,
      'dataUsage': dataUsage,
    };
  }
}
