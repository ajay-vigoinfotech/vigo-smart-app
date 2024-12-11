class LeaveBalanceModel {
  String? userId;
  String? leaveId;
  String? totalLeaves;

  LeaveBalanceModel({
    this.userId,
    this.leaveId,
    this.totalLeaves,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      userId: json['userId']?.toString(),
      leaveId: json['leaveId']?.toString(),
      totalLeaves: json['totalLeaves']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'leaveId': leaveId,
      'totalLeaves': totalLeaves,
    };
  }
}

class LeaveNameModel {
  String? leaveId;
  String? shortCode;
  String? leaveName;
  String? leaveId1;
  String? yearIdFrom;
  String? monthIdFrom;
  String? yearTo;
  String? monthIdTo;
  String? yearlyLeave;
  String? monthlyLeave;
  String? totalYearlyLeave;
  String? totalMonthlyLeave;
  String? carryForword;

  LeaveNameModel({
    this.leaveId,
    this.shortCode,
    this.leaveName,
    this.leaveId1,
    this.yearIdFrom,
    this.monthIdFrom,
    this.yearTo,
    this.monthIdTo,
    this.yearlyLeave,
    this.monthlyLeave,
    this.totalYearlyLeave,
    this.totalMonthlyLeave,
    this.carryForword,
  });

  factory LeaveNameModel.fromJson(Map<String, dynamic> json) {
    return LeaveNameModel(
      leaveId: json['leaveId']?.toString(),
      shortCode: json['shortCode']?.toString(),
      leaveName: json['leaveName']?.toString(),
      leaveId1: json['leaveId1']?.toString(),
      yearIdFrom: json['yearIdFrom']?.toString(),
      monthIdFrom: json['monthIdFrom']?.toString(),
      yearTo: json['yearTo']?.toString(),
      monthIdTo: json['monthIdTo']?.toString(),
      yearlyLeave: json['yearlyLeave']?.toString(),
      monthlyLeave: json['monthlyLeave']?.toString(),
      totalYearlyLeave: json['totalYearlyLeave']?.toString(),
      totalMonthlyLeave: json['totalMonthlyLeave']?.toString(),
      carryForword: json['carryForword']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveId': leaveId,
      'shortCode': shortCode,
      'leaveName': leaveName,
      'leaveId1': leaveId1,
      'yearIdFrom': yearIdFrom,
      'monthIdFrom': monthIdFrom,
      'yearTo': yearTo,
      'monthIdTo': monthIdTo,
      'yearlyLeave': yearlyLeave,
      'monthlyLeave': monthlyLeave,
      'totalYearlyLeave': totalYearlyLeave,
      'totalMonthlyLeave': totalMonthlyLeave,
      'carryForword': carryForword,
    };
  }
}

class LeaveBalanceResponse {
  List<LeaveBalanceModel> table;
  List<LeaveNameModel> table1;

  LeaveBalanceResponse({
    required this.table,
    required this.table1,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => LeaveBalanceModel.fromJson(e))
              .toList() ??
          [],
      table1: (json['table1'] as List<dynamic>?)
              ?.map((e) => LeaveNameModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
      'table1': table1.map((e) => e.toJson()).toList(),
    };
  }
}
