class GetAssignSitesListModel {
  String? siteId;
  String? compID;
  String? clientId;
  String? siteName;
  String? siteCode;
  String? unitName;
  String? clientName;

  GetAssignSitesListModel({
    required this.siteId,
    required this.compID,
    required this.clientId,
    required this.siteName,
    required this.siteCode,
    required this.unitName,
    required this.clientName,
  });

  factory GetAssignSitesListModel.fromJson(Map<String, dynamic> json) {
    return GetAssignSitesListModel(
      siteId: json['siteId']?.toString() ?? '',
      compID: json['compID']?.toString() ?? '',
      clientId: json['clientId']?.toString() ?? '',
      siteName: json['siteName']?.toString() ?? '',
      siteCode: json['siteCode']?.toString() ?? '',
      unitName: json['unitName']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'siteId': siteId,
      'compID': compID,
      'clientId': clientId,
      'siteName': siteName,
      'siteCode': siteCode,
      'unitName': unitName,
      'clientName': clientName,
    };
  }
}

class GetAssignSitesListResponse {
  List<GetAssignSitesListModel> table;

  GetAssignSitesListResponse({
    required this.table,
  });

  factory GetAssignSitesListResponse.fromJson(Map<String, dynamic> json) {
    return GetAssignSitesListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => GetAssignSitesListModel.fromJson(
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
