class PreRecruitmentListModel {
  String? userId;
  String? employeeCode;
  String? fullName;
  String? mobilePIN;
  String? image;
  String? createDate;
  String? statusId;
  String? statusCode;
  String? statusName;
  String? designationName;

  PreRecruitmentListModel({
    required this.userId,
    required this.employeeCode,
    required this.fullName,
    required this.mobilePIN,
    required this.image,
    required this.createDate,
    required this.statusId,
    required this.statusCode,
    required this.statusName,
    required this.designationName,

  });

  factory PreRecruitmentListModel.fromJson(Map<String, dynamic> json) {
    return PreRecruitmentListModel(
      userId: json['userId']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      mobilePIN: json['mobilePIN']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      createDate: json['createDate']?.toString() ?? '',
      statusId: json['statusId']?.toString() ?? '',
      statusCode: json['statusCode']?.toString() ?? '',
      statusName: json['statusName']?.toString() ?? '',
      designationName: json['designationName']?.toString() ?? '',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'employeeCode': employeeCode,
      'fullName': fullName,
      'mobilePIN': mobilePIN,
      'image': image,
      'createDate': createDate,
      'statusId': statusId,
      'statusCode': statusCode,
      'statusName': statusName,
      'designationName': designationName,
    };
  }
}


class PreRecruitmentListResponse{
  List<PreRecruitmentListModel> table;

  PreRecruitmentListResponse({
    required this.table,
  });

  factory PreRecruitmentListResponse.fromJson(Map<String, dynamic> json) {
    return PreRecruitmentListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => PreRecruitmentListModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table.map((e) => e.toJson()).toList(),
    };
  }
}

