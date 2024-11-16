class TeamViewActivityAttendanceModel {
  String? userId;
  String? fullName;

  TeamViewActivityAttendanceModel({
    required this.userId,
    required this.fullName
  });

  // Factory constructor to create the object from JSON
  factory TeamViewActivityAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TeamViewActivityAttendanceModel(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
    };
  }
}

  class TeamViewActivityAttendanceResponse {
    List<TeamViewActivityAttendanceModel> table;

    TeamViewActivityAttendanceResponse({
      required this.table,
    });

    factory TeamViewActivityAttendanceResponse.fromJson(Map<String, dynamic> json) {
      return TeamViewActivityAttendanceResponse(
        table: (json['table'] as List<dynamic>?)
            ?.map((e) => TeamViewActivityAttendanceModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'table' : table.map((e) => e.toJson()).toList(),
      };
    }
  }




