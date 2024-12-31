class GetStateModel {
  String? value;
  String? text;
  String? parentId;

  GetStateModel({
    required this.value,
    required this.text,
    required this.parentId,
  });

  factory GetStateModel.fromJson(Map<String, dynamic> json) {
    return GetStateModel(
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
