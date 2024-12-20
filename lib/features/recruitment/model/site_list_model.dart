class SiteListModel {
  String? siteId;
  String? compID;
  String? clientId;
  String? siteName;
  String? siteCode;
  String? unitName;
  String? clientName;

  SiteListModel({
    required this.siteId,
    required this.compID,
    required this.clientId,
    required this.siteName,
    required this.siteCode,
    required this.unitName,
    required this.clientName,
  });

  factory SiteListModel.fromJson(Map<String, dynamic> json) {
    return SiteListModel(
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

class SiteListResponse {
  List<SiteListModel> table;

  SiteListResponse({
    required this.table,
  });

  factory SiteListResponse.fromJson(Map<String, dynamic> json) {
    return SiteListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => SiteListModel.fromJson(e))
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
