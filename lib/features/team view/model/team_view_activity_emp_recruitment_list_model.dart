class TeamViewActivityEmpRecruitmentListModel {
  String? userId;
  String? fullName;

  TeamViewActivityEmpRecruitmentListModel({
    required this.userId,
    required this.fullName,
  });

  factory TeamViewActivityEmpRecruitmentListModel.fromJson(Map<String, dynamic> json) {
    return TeamViewActivityEmpRecruitmentListModel(
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
    };
  }
}

class TeamViewActivityEmpRecruitmentListResponse {
  List<TeamViewActivityEmpRecruitmentListModel> table;

  TeamViewActivityEmpRecruitmentListResponse({
    required this.table,
  });

  factory TeamViewActivityEmpRecruitmentListResponse.fromJson(
      Map<String, dynamic> json) {
    return TeamViewActivityEmpRecruitmentListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => TeamViewActivityEmpRecruitmentListModel.fromJson(
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


