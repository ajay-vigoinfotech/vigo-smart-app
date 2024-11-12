class TeamDashboardSiteCountModel {
  int? employeeSiteVisitCount;
  int? employeeCount;
  int? employeeSiteNotVisitCount;

  TeamDashboardSiteCountModel({
    required this.employeeSiteVisitCount,
    this.employeeCount,
    this.employeeSiteNotVisitCount,
  });

  factory TeamDashboardSiteCountModel.fromJson(Map<String, dynamic> json) {
    return TeamDashboardSiteCountModel(
      employeeSiteVisitCount: json['employeesitevisitcount'] ?? 0,
      employeeCount: json['employeecount'] ?? 0,
      employeeSiteNotVisitCount: json['employeesitenotvisitcount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeesitevisitcount': employeeSiteVisitCount,
      'employeecount': employeeCount,
      'employeesitenotvisitcount': employeeSiteNotVisitCount,
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

class SiteDashboardResponse {
  List<TeamDashboardSiteCountModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  SiteDashboardResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory SiteDashboardResponse.fromJson(Map<String, dynamic> json) {
    return SiteDashboardResponse(
      table: (json['table'] as List<dynamic>)
          .map((e) => TeamDashboardSiteCountModel.fromJson(e))
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