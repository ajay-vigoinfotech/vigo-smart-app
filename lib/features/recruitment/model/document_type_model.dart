class DocumentTypeModel {
  String? value;
  String? text;
  String? parentId;

  DocumentTypeModel({
    required this.value,
    required this.text,
    required this.parentId,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
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
