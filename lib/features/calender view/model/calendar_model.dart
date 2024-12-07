class CalendarModel {
  String? attendanceDate;
  String? code;
  String? status;

  CalendarModel(
      {required this.attendanceDate, required this.code, required this.status});

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
        attendanceDate: json['attendanceDate']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        status: json['status']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceDate': attendanceDate,
      'code': code,
      'status': status,
    };
  }
}

class CalendarModelResponse {
  List<CalendarModel> table;

  CalendarModelResponse({
    required this.table,
  });

  factory CalendarModelResponse.fromJson(Map<String, dynamic> json) {
    return CalendarModelResponse(
        table: (json['table'] as List<dynamic>?)
                ?.map((e) => CalendarModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            []);
  }
  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
    };
  }
}
