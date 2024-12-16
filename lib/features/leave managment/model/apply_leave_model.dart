class ApplyLeaveModel {
  String? dateTo;
  String? action;
  String? remark;
  String? leaveTypeId;
  String? dateFrom;

  ApplyLeaveModel({
    required this.dateTo,
    required this.action,
    required this.remark,
    required this.leaveTypeId,
    required this.dateFrom,
  });

  factory ApplyLeaveModel.fromJson(Map<String, dynamic> json) {
    return ApplyLeaveModel(
      dateTo: json['dateTo']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      remark: json['remark']?.toString() ?? '',
      leaveTypeId: json['leaveTypeId']?.toString() ?? '',
      dateFrom: json['dateFrom']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTo': dateTo,
      'action': action,
      'remark': remark,
      'leaveTypeId': leaveTypeId,
      'dateFrom': dateFrom,
    };
  }
}


