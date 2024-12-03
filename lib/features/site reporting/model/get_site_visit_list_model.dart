class GetSiteVisitListModel {
  String? checkinId;
  String? compId;
  String? userId;
  String? checkinTypeName;
  String? clientSiteId;
  String? unitName;
  String? inRemarks;
  String? dateTimeIn;

  GetSiteVisitListModel({
    required this.checkinId,
    required this.compId,
    required this.userId,
    required this.checkinTypeName,
    required this.clientSiteId,
    required this.unitName,
    required this.inRemarks,
    required this.dateTimeIn,
  });

  factory GetSiteVisitListModel.fromJson(Map<String, dynamic> json) {
    return GetSiteVisitListModel(
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

class GetSiteVisitListResponse {
  List<GetSiteVisitListModel> table;

  GetSiteVisitListResponse({
    required this.table,
  });

  factory GetSiteVisitListResponse.fromJson(Map<String, dynamic> json) {
    return GetSiteVisitListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) =>
                  GetSiteVisitListModel.fromJson(e as Map<String, dynamic>))
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
