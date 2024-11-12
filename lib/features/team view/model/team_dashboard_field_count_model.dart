class TeamDashboardFieldCountModel {
  int? employeeFieldVisitCount;
  int? employeeCount;
  int? employeeFieldNotVisitCount;

  TeamDashboardFieldCountModel({
    required this.employeeFieldVisitCount,
    this.employeeCount,
    this.employeeFieldNotVisitCount,
  });

  factory TeamDashboardFieldCountModel.fromJson(Map<String, dynamic> json) {
    return TeamDashboardFieldCountModel(
      employeeFieldVisitCount: json['employeefieldvisitcount '] ?? 0,
      employeeCount: json['employeecount'] ?? 0,
      employeeFieldNotVisitCount: json['employeefieldnotvisitcount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeefieldvisitcount': employeeFieldVisitCount,
      'employeecount': employeeCount,
      'employeefieldnotvisitcount': employeeFieldNotVisitCount,
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

class FieldDashboardResponse {
  List<TeamDashboardFieldCountModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  FieldDashboardResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory FieldDashboardResponse.fromJson(Map<String, dynamic> json) {
    return FieldDashboardResponse(
      table: (json['table'] as List<dynamic>)
          .map((e) => TeamDashboardFieldCountModel.fromJson(e))
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