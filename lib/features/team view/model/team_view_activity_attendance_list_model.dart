class TeamViewActivityAttendanceListModel {
  String? compId;
  String? dateTimeIn;
  String? dateTimeOut;
  String? totalHours;
  String? checkinTypeCode;
  String? location;
  String? outLocation;
  String? inRemarks;
  String? inPhoto;
  String? outPhoto;
  String? outRemarks;
  String? inKmsDriven;
  String? outKmsDriven;

  TeamViewActivityAttendanceListModel({
    required this.compId,
    required this.dateTimeIn,
    required this.dateTimeOut,
    required this.totalHours,
    required this.checkinTypeCode,
    required this.location,
    required this.outLocation,
    required this.inRemarks,
    required this.inPhoto,
    required this.outPhoto,
    required this.outRemarks,
    required this.inKmsDriven,
    required this.outKmsDriven,
  });

  factory TeamViewActivityAttendanceListModel.fromJson(
      Map<String, dynamic> json) {
    return TeamViewActivityAttendanceListModel(
      compId: json['compId']?.toString() ?? '',
      dateTimeIn: json['dateTimeIn']?.toString() ?? '',
      dateTimeOut: json['dateTimeOut']?.toString() ?? '',
      totalHours: json['totalHours']?.toString() ?? '',
      checkinTypeCode: json['checkinTypeCode']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      outLocation: json['outLocation']?.toString() ?? '',
      inRemarks: json['inRemarks']?.toString() ?? '',
      inPhoto: json['inPhoto']?.toString() ?? '',
      outPhoto: json['outPhoto']?.toString() ?? '',
      outRemarks: json['outRemarks']?.toString() ?? '',
      inKmsDriven: json['inKmsDriven']?.toString() ?? '',
      outKmsDriven: json['outKmsDriven']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compId': compId,
      'dateTimeIn': dateTimeIn,
      'dateTimeOut': dateTimeOut,
      'totalHours': totalHours,
      'checkinTypeCode': checkinTypeCode,
      'location': location,
      'outLocation': outLocation,
      'inRemarks': inRemarks,
      'inPhoto': inPhoto,
      'outPhoto': outPhoto,
      'outRemarks': outRemarks,
      'inKmsDriven': inKmsDriven,
      'outKmsDriven': outKmsDriven,
    };
  }
}

class TeamViewActivityAttendanceListResponse {
  List<TeamViewActivityAttendanceListModel> table;

  TeamViewActivityAttendanceListResponse({
    required this.table,
  });

  factory TeamViewActivityAttendanceListResponse.fromJson(
      Map<String, dynamic> json) {
    return TeamViewActivityAttendanceListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => TeamViewActivityAttendanceListModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
    };
  }
}
