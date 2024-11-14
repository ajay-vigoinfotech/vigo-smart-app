class TeamViewPatrollingListModel {
  String? fullName;
  int? counts;
  String? status;

  TeamViewPatrollingListModel({
    required this.fullName,
    required this.counts,
    required this.status,
  });

  factory TeamViewPatrollingListModel.fromJson(Map<String, dynamic> json) {
    return TeamViewPatrollingListModel(
      fullName: json['fullName'] as String? ?? '',
      counts: json['counts'] ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'counts': counts,
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

class PatrollingListResponse {
  List<TeamViewPatrollingListModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  PatrollingListResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory PatrollingListResponse.fromJson(Map<String, dynamic> json) {
    return PatrollingListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => TeamViewPatrollingListModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      httpResponseStatus: (json['httpResponseStatus'] as List<dynamic>?)
              ?.map(
                  (e) => HttpResponseStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
      'httpResponseStatus': httpResponseStatus.map((e) => e.toJson()).toList(),
    };
  }
}
