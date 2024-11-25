class GetFieldReportingModel {
  String? compId;
  String? dateTimeIn;
  String? checkinTypeCode;
  String? inPhoto;
  String? location;
  String? checkInRemarks;

  GetFieldReportingModel({
    required this.compId,
    required this.dateTimeIn,
    required this.checkinTypeCode,
    required this.inPhoto,
    required this.location,
    required this.checkInRemarks,
  });

  factory GetFieldReportingModel.fromJson(Map<String, dynamic> json) {
    return GetFieldReportingModel(
      compId: json['compId']?.toString() ?? '',
      dateTimeIn: json['dateTimeIn']?.toString() ?? '',
      checkinTypeCode: json['checkinTypeCode']?.toString() ?? '',
      inPhoto: json['inPhoto']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      checkInRemarks: json['checkInRemarks']?.toString() ?? '',
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'compId' : compId,
      'dateTimeIn' : dateTimeIn,
      'checkinTypeCode' : checkinTypeCode,
      'inPhoto' : inPhoto,
      'location' : location,
      'checkInRemarks' : checkInRemarks,
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
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'],
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

class GetFieldReportingResponse {
  List<GetFieldReportingModel> table;

  GetFieldReportingResponse({
    required this.table,
});

  factory GetFieldReportingResponse.fromJson(
      Map<String, dynamic> json) {
    return GetFieldReportingResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => GetFieldReportingModel.fromJson(
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
