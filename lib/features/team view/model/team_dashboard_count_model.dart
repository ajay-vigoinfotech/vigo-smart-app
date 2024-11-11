class TeamDashboardCountModel {
  int employeeCount;
  int? presentEmployeeCount;
  int? absentEmployeeCount;
  int? lateEmployeeCount;

  TeamDashboardCountModel({
    required this.employeeCount,
    this.presentEmployeeCount,
    this.absentEmployeeCount,
    this.lateEmployeeCount,
  });

  factory TeamDashboardCountModel.fromJson(Map<String, dynamic> json) {
    return TeamDashboardCountModel(
      employeeCount: json['employeecount'] ?? 2,
      presentEmployeeCount: json['presentemployeecount'],
      absentEmployeeCount: json['absentemployeecount'],
      lateEmployeeCount: json['lateemployeecount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeecount': employeeCount,
      'presentemployeecount': presentEmployeeCount,
      'absentemployeecount': absentEmployeeCount,
      'lateemployeecount': lateEmployeeCount,
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

class TeamDashboardResponse {
  List<TeamDashboardCountModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  TeamDashboardResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory TeamDashboardResponse.fromJson(Map<String, dynamic> json) {
    return TeamDashboardResponse(
      table: (json['table'] as List<dynamic>)
          .map((e) => TeamDashboardCountModel.fromJson(e))
          .toList(),
      httpResponseStatus: (json['httpResponseStatus'] as List<dynamic>)
          .map((e) => HttpResponseStatus.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
      'httpResponseStatus': httpResponseStatus.map((e) => e.toJson()).toList(),
    };
  }
}
