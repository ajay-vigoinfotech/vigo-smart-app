class BranchListModel {
  String? branchId;
  String? compId;
  String? branchName;
  String? branchCode;
  String? branchAddress;
  String? empBranchCode;
  String? createdBy;
  String? createdAt;
  String? modifiedBy;
  String? modifiedAt;
  String? isVisible;

  BranchListModel({
    required this.branchId,
    required this.compId,
    required this.branchName,
    required this.branchCode,
    required this.branchAddress,
    required this.empBranchCode,
    required this.createdBy,
    required this.createdAt,
    required this.modifiedBy,
    required this.modifiedAt,
    required this.isVisible,
  });

  factory BranchListModel.fromJson(Map<String, dynamic> json) {
    return BranchListModel(
      branchId: json['branchId']?.toString() ?? '',
      compId: json['compId']?.toString() ?? '',
      branchName: json['branchName']?.toString() ?? '',
      branchCode: json['branchCode']?.toString() ?? '',
      branchAddress: json['branchAddress']?.toString() ?? '',
      empBranchCode: json['empBranchCode']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      modifiedBy: json['modifiedBy']?.toString() ?? '',
      modifiedAt: json['modifiedAt']?.toString() ?? '',
      isVisible: json['isVisible']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'compId': compId,
      'branchName': branchName,
      'branchCode': branchCode,
      'branchAddress': branchAddress,
      'empBranchCode': empBranchCode,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'modifiedBy': modifiedBy,
      'modifiedAt': modifiedAt,
      'isVisible': isVisible,
    };
  }
}

class BranchListResponse {
  List<BranchListModel> table;

  BranchListResponse({
    required this.table,
  });

  factory BranchListResponse.fromJson(Map<String, dynamic> json) {
    return BranchListResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) => BranchListModel.fromJson(e))
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
