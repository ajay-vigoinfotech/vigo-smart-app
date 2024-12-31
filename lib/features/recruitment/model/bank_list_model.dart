class BankListModel {
  String? bankId;
  String? shortCode;
  String? bankName;

  BankListModel({
    required this.bankId,
    required this.shortCode,
    required this.bankName,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) {
    return BankListModel(
      bankId: json['bankId']?.toString() ?? '',
      shortCode: json['shortCode']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'shortCode': shortCode,
      'bankName': bankName
    };
  }
}

class BankListResponse {
  List<BankListModel> table;

  BankListResponse({
    required this.table,
  });

  factory BankListResponse.fromJson(Map<String, dynamic> json) {
    return BankListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => BankListModel.fromJson(e))
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
