class DuplicateAadhaarModel {
  String? userId;
  String? aadharNum;
  String? statusId;
  String? employeeCode;
  String? fullName;

  DuplicateAadhaarModel({
    required this.userId,
    required this.aadharNum,
    required this.statusId,
    required this.employeeCode,
    required this.fullName,
  });

  factory DuplicateAadhaarModel.fromJson(Map<String, dynamic> json) {
    return DuplicateAadhaarModel(
      userId: json['userId']?.toString() ?? '',
      aadharNum: json['aadharNum']?.toString() ?? '',
      statusId: json['statusId']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'aadharNum': aadharNum,
      'statusId': statusId,
      'employeeCode': employeeCode,
      'fullName': fullName,
    };
  }
}

class HttpResponseStatus {
  int code;
  String status;
  String? message;

  HttpResponseStatus({
    required this.code,
    required this.status,
    this.message,
  });

  factory HttpResponseStatus.fromJson(Map<String, dynamic> json) {
    return HttpResponseStatus(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
    };
  }
}

class DuplicateAadhaarResponse {
  List<DuplicateAadhaarModel> table;
  List<HttpResponseStatus> httpResponseStatus;

  DuplicateAadhaarResponse({
    required this.table,
    required this.httpResponseStatus,
  });

  factory DuplicateAadhaarResponse.fromJson(Map<String, dynamic> json) {
    return DuplicateAadhaarResponse(
      table: (json['table'] as List<dynamic>)
          .map((e) => DuplicateAadhaarModel.fromJson(e))
          .toList(),
      httpResponseStatus: (json['httpResponseStatus'] as List<dynamic>)
          .map((e) => HttpResponseStatus.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
      'httpResponseStatus': httpResponseStatus.map((e) => e.toJson()).toList(),
    };
  }
}
