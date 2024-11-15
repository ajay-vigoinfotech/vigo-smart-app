class TeamViewSiteListModel {
  String? fullName;
  int? counts;
  String? status;

  TeamViewSiteListModel({
    required this.fullName,
    required this.counts,
    required this.status,
  });

  factory TeamViewSiteListModel.fromJson(Map<String, dynamic> json) {
    return TeamViewSiteListModel(
      fullName: json['fullName'] as String? ?? '',
      counts: json['counts'] as int? ?? 0,
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

class SiteListResponse {
  List<TeamViewSiteListModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  SiteListResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory SiteListResponse.fromJson(Map<String, dynamic> json) {
    return SiteListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => TeamViewSiteListModel.fromJson(
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
