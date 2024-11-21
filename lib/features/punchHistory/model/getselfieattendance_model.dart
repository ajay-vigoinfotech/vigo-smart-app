class GetSelfieAttendanceModel {
  String? compId;
  String? dateTimeIn;
  String? dateTimeOut;
  String? totalHours;
  String? location;
  String? outLocation;
  String? inRemarks;
  String? inPhoto;
  String? outPhoto;
  String? outRemarks;
  String? inKmsDriven; // Changed to String
  String? outKmsDriven; // Changed to String

  GetSelfieAttendanceModel({
    required this.compId,
    required this.dateTimeIn,
    required this.dateTimeOut,
    required this.totalHours,
    required this.location,
    required this.outLocation,
    required this.inRemarks,
    required this.inPhoto,
    required this.outPhoto,
    required this.outRemarks,
    required this.inKmsDriven,
    required this.outKmsDriven,
  });

  factory GetSelfieAttendanceModel.fromJson(Map<String, dynamic> json) {
    return GetSelfieAttendanceModel(
      compId: json['compId']?.toString() ?? '',
      dateTimeIn: json['dateTimeIn']?.toString() ?? '',
      dateTimeOut: json['dateTimeOut']?.toString() ?? '',
      totalHours: json['totalHours']?.toString() ?? '',
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



class HttpResponseStatus {
  int code;
  String status;
  String? message;

  HttpResponseStatus({
    required this.code,
    required this.status,
    this.message,
  });

  factory HttpResponseStatus.fromJson(Map<String, dynamic> json) {
    return HttpResponseStatus(
      code: json['code'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
    };
  }
}

class GetSelfieAttendanceResponse{
  List<GetSelfieAttendanceModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  GetSelfieAttendanceResponse({
    required this.table,
    required this.httpResponseStatus,
});

  factory GetSelfieAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return GetSelfieAttendanceResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => GetSelfieAttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      httpResponseStatus: (json['httpResponseStatus'] as List<dynamic>?)
          ?.map((e) => HttpResponseStatus.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
      'httpResponseStatus': httpResponseStatus.map((e) => e.toJson()).toList(),
    };
  }
}

