class TeamViewActivitySiteReportListModel {
  String? checkinId;
  String? compId;
  String? userId;
  String? checkinTypeName;
  String? clientSiteId;
  String? unitName;
  String? inRemarks;
  String? dateTimeIn;

  TeamViewActivitySiteReportListModel({
    required this.checkinId,
    required this.compId,
    required this.userId,
    required this.checkinTypeName,
    required this.clientSiteId,
    required this.unitName,
    required this.inRemarks,
    required this.dateTimeIn,
  });

  factory TeamViewActivitySiteReportListModel.fromJson(
      Map<String, dynamic> json) {
    return TeamViewActivitySiteReportListModel(
      checkinId: json['checkinId']?.toString() ?? '',
      compId: json['compId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      checkinTypeName: json['checkinTypeName']?.toString() ?? '',
      clientSiteId: json['clientSiteId']?.toString() ?? '',
      unitName: json['unitName']?.toString() ?? '',
      inRemarks: json['inRemarks']?.toString() ?? '',
      dateTimeIn: json['dateTimeIn']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkinId': checkinId,
      'compId': compId,
      'userId': userId,
      'checkinTypeName': checkinTypeName,
      'clientSiteId': clientSiteId,
      'unitName': unitName,
      'inRemarks': inRemarks,
      'dateTimeIn': dateTimeIn,
    };
  }
}

class TeamViewActivitySiteReportListResponse {
  List<TeamViewActivitySiteReportListModel> table;

  TeamViewActivitySiteReportListResponse({
    required this.table,
  });

  factory TeamViewActivitySiteReportListResponse.fromJson(
      Map<String, dynamic> json) {
    return TeamViewActivitySiteReportListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => TeamViewActivitySiteReportListModel.fromJson(
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
