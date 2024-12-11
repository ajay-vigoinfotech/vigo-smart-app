class LeaveHistoryModel {
  String? employeesLeaveId;
  String? userId;
  String? employeeCode;
  String? fullName;
  String? leaveEnableDisable;
  String? leavePendingApprove;
  String? leaveType;
  String? dateFrom;
  String? dateTo;
  String? remark;
  String? createdAt;
  String? createdBy;
  String? leavesListId;
  String? noOfDays;

  LeaveHistoryModel({
    required this.employeesLeaveId,
    required this.userId,
    required this.employeeCode,
    required this.fullName,
    required this.leaveEnableDisable,
    required this.leavePendingApprove,
    required this.leaveType,
    required this.dateFrom,
    required this.dateTo,
    required this.remark,
    required this.createdAt,
    required this.createdBy,
    required this.leavesListId,
    required this.noOfDays,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      employeesLeaveId: json['employeesLeaveId']?.toString(),
      userId: json['userId']?.toString(),
      employeeCode: json['employeeCode']?.toString(),
      fullName: json['fullName']?.toString(),
      leaveEnableDisable: json['leaveEnableDisable']?.toString(),
      leavePendingApprove: json['leavePendingApprove']?.toString(),
      leaveType: json['leaveType']?.toString(),
      dateFrom: json['dateFrom']?.toString(),
      dateTo: json['dateTo']?.toString(),
      remark: json['remark']?.toString(),
      createdAt: json['createdAt']?.toString(),
      createdBy: json['createdBy']?.toString(),
      leavesListId: json['leavesListId']?.toString(),
      noOfDays: json['noOfDays']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeesLeaveId': employeesLeaveId,
      'userId': userId,
      'employeeCode': employeeCode,
      'fullName': fullName,
      'leaveEnableDisable': leaveEnableDisable,
      'leavePendingApprove': leavePendingApprove,
      'leaveType': leaveType,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'remark': remark,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'leavesListId': leavesListId,
      'noOfDays': noOfDays,
    };
  }
}

class LeaveHistoryResponse {
  List<LeaveHistoryModel> table;

  LeaveHistoryResponse({
    required this.table,
  });

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
        table: (json['table'] as List<dynamic>?)
                ?.map((e) => LeaveHistoryModel.fromJson(e))
                .toList() ??
            []
    );
  }
}
