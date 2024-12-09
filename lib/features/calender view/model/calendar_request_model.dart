class CalendarRequestModel {
  String? month;
  String? year;

  CalendarRequestModel({
    required this.month,
    required this.year,
  });

  factory CalendarRequestModel.fromJson(Map<String, dynamic> json) {
    return CalendarRequestModel(
      month: json['month'].toString(),
      year: json['year'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
    };
  }
}
