class SubmitEmployeeModel {
  String? employeesLeaveId;
  String? userId;
  String? dateFrom;
  String? dateTo;

  SubmitEmployeeModel({
    required this.employeesLeaveId,
    required this.userId,
    required this.dateFrom,
    required this.dateTo,
  });

  factory SubmitEmployeeModel.fromJson(Map<String, dynamic> json) {
    return SubmitEmployeeModel(
      employeesLeaveId: json['employeesLeaveId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      dateFrom: json['dateFrom']?.toString() ?? '',
      dateTo: json['dateTo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeesLeaveId': employeesLeaveId,
      'userId': userId,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
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

class SubmitEmployeeResponse {
  List<SubmitEmployeeModel> table;

  SubmitEmployeeResponse({
    required this.table,
  });

  factory SubmitEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return SubmitEmployeeResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) =>
                  SubmitEmployeeModel.fromJson(e as Map<String, dynamic>))
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
