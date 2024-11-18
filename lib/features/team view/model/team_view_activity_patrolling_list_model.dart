class TeamViewActivityPatrollingListModel {
  String? compId;
  String? dateTimeIn;
  String? checkinTypeCode;
  String? inPhoto;
  String? location;
  String? checkInRemarks;

  TeamViewActivityPatrollingListModel({
    required this.compId,
    required this.dateTimeIn,
    required this.checkinTypeCode,
    required this.inPhoto,
    required this.location,
    required this.checkInRemarks,
});

  factory TeamViewActivityPatrollingListModel.fromJson(Map<String, dynamic> json) {
    return TeamViewActivityPatrollingListModel(
        compId: json['compId']?.toString() ?? '',
        dateTimeIn: json['dateTimeIn']?.toString() ?? '',
        checkinTypeCode: json['checkinTypeCode']?.toString() ?? '',
        inPhoto: json['inPhoto']?.toString() ?? '',
        location: json['location']?.toString() ?? '',
        checkInRemarks:json['checkInRemarks']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compId': compId,
      'dateTimeIn': dateTimeIn,
      'checkinTypeCode': checkinTypeCode,
      'inPhoto': inPhoto,
      'location': location,
      'checkInRemarks' : checkInRemarks,
    };
  }
}

class TeamViewActivityPatrollingListResponse {
  List<TeamViewActivityPatrollingListModel> table;

  TeamViewActivityPatrollingListResponse({
    required this.table,
  });

  factory TeamViewActivityPatrollingListResponse.fromJson(
      Map<String, dynamic> json) {
    return TeamViewActivityPatrollingListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => TeamViewActivityPatrollingListModel.fromJson(
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


