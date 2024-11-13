class TeamViewAttendanceListModel {
  String? fullName;
  String? userId;
  String? dateTimeIn;
  String? dateTimeOut;
  String? status;

  TeamViewAttendanceListModel({
    required this.fullName,
    required this.userId,
    required this.dateTimeIn,
    required this.dateTimeOut,
    required this.status,
  });

  factory TeamViewAttendanceListModel.fromJson(Map<String, dynamic> json) {
    return TeamViewAttendanceListModel(
      fullName: json['fullName'] as String?,
      userId: json['userId'] as String?,
      dateTimeIn: json['dateTimeIn'] as String?,
      dateTimeOut: json['dateTimeOut'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'userId': userId,
      'dateTimeIn': dateTimeIn,
      'dateTimeOut': dateTimeOut,
      'status': status,
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

class AttendanceListResponse {
  List<TeamViewAttendanceListModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  AttendanceListResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory AttendanceListResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => TeamViewAttendanceListModel.fromJson(e as Map<String, dynamic>))
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
