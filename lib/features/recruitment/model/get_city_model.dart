class GetCityModel {
  String? value;
  String? text;
  String? parentId;

  GetCityModel({
    required this.value,
    required this.text,
    required this.parentId,
  });

  factory GetCityModel.fromJson(Map<String, dynamic> json) {
    return GetCityModel(
      value: json['value']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text,
      'parentId': parentId,
    };
  }
}
