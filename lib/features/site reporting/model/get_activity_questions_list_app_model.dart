class GetActivityQuestionsListAppModel {
  String? activityId;
  String? activityName;
  String? questionId;
  String? questionName;

  GetActivityQuestionsListAppModel({
    required this.activityId,
    required this.activityName,
    required this.questionId,
    required this.questionName,
  });

  factory GetActivityQuestionsListAppModel.fromJson(Map<String, dynamic> json) {
    return GetActivityQuestionsListAppModel(
      activityId: json['activityId']?.toString() ?? '',
      activityName: json['activityName']?.toString() ?? '',
      questionId: json['questionId']?.toString() ?? '',
      questionName: json['questionName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'activityName': activityName,
      'questionId': questionId,
      'questionName': questionName,
    };
  }
}

class GetActivityQuestionsListAppResponse {
  List<GetActivityQuestionsListAppModel> table;

  GetActivityQuestionsListAppResponse({
    required this.table,
  });

  factory GetActivityQuestionsListAppResponse.fromJson(
      Map<String, dynamic> json) {
    return GetActivityQuestionsListAppResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => GetActivityQuestionsListAppModel.fromJson(
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
