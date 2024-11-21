class TeamViewActivityPatrollingModel {
  String? userId;
  String? fullName;

  TeamViewActivityPatrollingModel({
    required this.userId,
    required this.fullName,
});

  factory TeamViewActivityPatrollingModel.fromJson(Map<String, dynamic> json) {
    return TeamViewActivityPatrollingModel(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
    };
  }
}

class TeamViewActivityPatrollingResponse {
  List<TeamViewActivityPatrollingModel> table;

  TeamViewActivityPatrollingResponse({
    required this.table,
});

  factory TeamViewActivityPatrollingResponse.fromJson(Map<String, dynamic> json) {
    return TeamViewActivityPatrollingResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => TeamViewActivityPatrollingModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table' : table.map((e) => e.toJson()).toList(),
    };
  }
}



