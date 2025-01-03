class FamilyRelationModel {
  String? familyRelatonId;
  String? familyRelationCode;
  String? familyRelationName;

  FamilyRelationModel({
    required this.familyRelatonId,
    required this.familyRelationCode,
    required this.familyRelationName,
  });

  factory FamilyRelationModel.fromJson(Map<String, dynamic> json) {
    return FamilyRelationModel(
      familyRelatonId: json['familyRelatonId']?.toString() ?? '',
      familyRelationCode: json['familyRelationCode']?.toString() ?? '',
      familyRelationName: json['familyRelationName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familyRelatonId': familyRelatonId,
      'familyRelationCode': familyRelationCode,
      'familyRelationName': familyRelationName,
    };
  }
}

class FamilyRelationResponse {
  List<FamilyRelationModel>? table;

  FamilyRelationResponse({
    required this.table,
  });

  factory FamilyRelationResponse.fromJson(Map<String, dynamic> json) {
    return FamilyRelationResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => FamilyRelationModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table?.map((e) => e.toJson()).toList(),
    };
  }
}
