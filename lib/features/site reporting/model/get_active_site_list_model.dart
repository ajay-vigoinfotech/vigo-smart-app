class GetActiveSiteListModel {
  String? value;
  String? text;
  String? address;
  String? zone;
  String? strength;

  GetActiveSiteListModel({
    required this.value,
    required this.text,
    required this.address,
    required this.zone,
    required this.strength,
  });

  factory GetActiveSiteListModel.fromJson(Map<String, dynamic> json) {
    return GetActiveSiteListModel(
      value: json['value'].toString(),
      text: json['text'].toString(),
      address: json['address'].toString(),
      zone: json['zone'].toString(),
      strength: json['strength'].toString(),
    );
  }

  static List<GetActiveSiteListModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => GetActiveSiteListModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text,
      'address': address,
      'zone': zone,
      'strength': strength,
    };
  }
}
