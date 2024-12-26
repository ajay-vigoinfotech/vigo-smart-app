class DesignationListModel {
  String? designationId;
  String? designationCode;
  String? designationName;

  DesignationListModel({
    required this.designationId,
    required this.designationCode,
    required this.designationName,
  });

  factory DesignationListModel.fromJson(Map<String, dynamic> json) {
    return DesignationListModel(
      designationId: json['designationId']?.toString() ?? '',
      designationCode: json['designationCode']?.toString() ?? '',
      designationName: json['designationName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'designationId': designationId,
      'designationCode': designationCode,
      'designationName': designationName
    };
  }
}

class DesignationListResponse {
  List<DesignationListModel> table;

  DesignationListResponse({
    required this.table,
  });

  factory DesignationListResponse.fromJson(Map<String, dynamic> json) {
    return DesignationListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => DesignationListModel.fromJson(e))
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
