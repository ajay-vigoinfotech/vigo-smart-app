class UpdateRecruitment01Model {
  String? userId;
  String? fullName;
  String? lastName;
  String? fatherName;
  String? motherName;
  String? spouseName;
  String? contactNo;
  String? dob;
  String? gender;
  String? marritalStatus;
  String? branchId;
  String? siteId;
  String? designationId;
  String? pan;
  String? aadharno;
  String? userImage;
  String? userSign;
  String? aadharFront;
  String? aadharBack;

  UpdateRecruitment01Model({
    required this.userId,
    required this.fullName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.spouseName,
    required this.contactNo,
    required this.dob,
    required this.gender,
    required this.marritalStatus,
    required this.branchId,
    required this.siteId,
    required this.designationId,
    required this.pan,
    required this.aadharno,
    required this.userImage,
    required this.userSign,
    required this.aadharFront,
    required this.aadharBack,
  });

  factory UpdateRecruitment01Model.fromJson(Map<String, dynamic> json) {
    return UpdateRecruitment01Model(
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      motherName: json['motherName']?.toString() ?? '',
      spouseName: json['spouseName']?.toString() ?? '',
      contactNo: json['contactNo']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      marritalStatus: json['marritalStatus']?.toString() ?? '',
      branchId: json['branchId']?.toString() ?? '',
      siteId: json['siteId']?.toString() ?? '',
      designationId: json['designationId']?.toString() ?? '',
      pan: json['pan']?.toString() ?? '',
      aadharno: json['aadharno']?.toString() ?? '',
      userImage: json['userImage']?.toString() ?? '',
      userSign: json['userSign']?.toString() ?? '',
      aadharFront: json['aadharFront']?.toString() ?? '',
      aadharBack: json['aadharBack']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId' : userId,
      'fullName': fullName,
      'lastName': lastName,
      'fatherName': fatherName,
      'motherName': motherName,
      'spouseName': spouseName,
      'contactNo': contactNo,
      'dob': dob,
      'gender': gender,
      'marritalStatus': marritalStatus,
      'branchId': branchId,
      'siteId': siteId,
      'designationId': designationId,
      'pan': pan,
      'aadharno': aadharno,
      'userImage': userImage,
      'userSign': userSign,
      'aadharFront': aadharFront,
      'aadharBack': aadharBack,
    };
  }
}
