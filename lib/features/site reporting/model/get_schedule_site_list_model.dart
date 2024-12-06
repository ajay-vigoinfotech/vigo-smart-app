class GetScheduleSiteListModel {
  String? siteId;
  String? remarks;
  String? scheduleDate;
  String? scheduleDate1;
  String? statusText;
  String? unitName;
  String? createdBy;
  String? isActive;

  GetScheduleSiteListModel({
    required this.siteId,
    required this.remarks,
    required this.scheduleDate,
    required this.scheduleDate1,
    required this.statusText,
    required this.unitName,
    required this.createdBy,
    required this.isActive,
  });

  factory GetScheduleSiteListModel.fromJson(Map<String, dynamic> json) {
    return GetScheduleSiteListModel(
      siteId: json['siteId']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      scheduleDate: json['scheduleDate']?.toString() ?? '',
      scheduleDate1: json['scheduleDate1']?.toString() ?? '',
      statusText: json['statusText']?.toString() ?? '',
      unitName: json['unitName']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      isActive: json['isActive']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteId': siteId,
      'remarks': remarks,
      'scheduleDate': scheduleDate,
      'scheduleDate1': scheduleDate1,
      'statusText': statusText,
      'unitName': unitName,
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }
}

class GetScheduleSiteListResponse {
  List<GetScheduleSiteListModel> table;

  GetScheduleSiteListResponse ({
    required this.table,
});

  factory GetScheduleSiteListResponse.fromJson(Map<String, dynamic> json) {
    return GetScheduleSiteListResponse(
        table: (json['table'] as List<dynamic>?)
            ?.map((e) => GetScheduleSiteListModel.fromJson(
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
