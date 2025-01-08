class PreRecruitmentByIdModel {
  String? compId;
  String? userId;
  String? mobilePIN;
  String? altMobilePIN;
  String? employeeCode;
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? statusId;
  String? currentAddress;
  String? currentPin;
  String? currentStateId;
  String? currentCityId;
  String? currentPoliceStation;
  String? currentPostOffice;
  String? permanentPin;
  String? permanentStateId;
  String? permanentCityId;
  String? permanentPoliceStation;
  String? permanentPostOffice;
  String? permanentAddress;
  String? pan;
  String? aadharNum;
  String? gender;
  String? dob;
  String? placeOfBirth;
  String? image;
  String? fatherName;
  String? motherName;
  String? createDate;
  String? signature;
  String? emergencyEmail1;
  String? emergencyName1;
  String? emergencyContactDetails1;
  String? emergencyContactReferenceDetails1;
  String? bloodGroup;
  String? bankId;
  String? bankName;
  String? enteredBankName;
  String? accountHolderName;
  String? accntNo;
  String? ifscCode;
  String? branch;
  String? pfNo;
  String? esicNo;
  String? uanNo;
  String? doj;
  String? marritalStatus;
  String? spouseName;
  String? spouseAge;
  String? nomineeName;
  String? nomineeAge;
  String? nomineeRelation;
  String? oldCompany;
  String? oldDesignation;
  String? oldExperience;
  String? oldCompanyAdd;
  String? oldCompanyLeavingDate;
  String? oldCompanyLeavingDate1;
  String? height;
  String? weight;
  String? waist;
  String? chest;
  String? identificationMark;
  String? empTypeID;
  String? designationId;
  String? designationCode;
  String? designationName;
  String? branchId;
  String? siteId;
  String? siteCode;
  String? siteName;
  String? access;
  String? isApproved;
  String? isDeleted;
  String? isLockedOut;
  String? bankDocs;
  String? aadhaarDocs;

  PreRecruitmentByIdModel({
    this.compId,
    this.userId,
    this.mobilePIN,
    this.altMobilePIN,
    this.employeeCode,
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.statusId,
    this.currentAddress,
    this.currentPin,
    this.currentStateId,
    this.currentCityId,
    this.currentPoliceStation,
    this.currentPostOffice,
    this.permanentPin,
    this.permanentStateId,
    this.permanentCityId,
    this.permanentPoliceStation,
    this.permanentPostOffice,
    this.permanentAddress,
    this.pan,
    this.aadharNum,
    this.gender,
    this.dob,
    this.placeOfBirth,
    this.image,
    this.fatherName,
    this.motherName,
    this.createDate,
    this.signature,
    this.emergencyEmail1,
    this.emergencyName1,
    this.emergencyContactDetails1,
    this.emergencyContactReferenceDetails1,
    this.bloodGroup,
    this.bankId,
    this.bankName,
    this.enteredBankName,
    this.accountHolderName,
    this.accntNo,
    this.ifscCode,
    this.branch,
    this.pfNo,
    this.esicNo,
    this.uanNo,
    this.doj,
    this.marritalStatus,
    this.spouseName,
    this.spouseAge,
    this.nomineeName,
    this.nomineeAge,
    this.nomineeRelation,
    this.oldCompany,
    this.oldDesignation,
    this.oldExperience,
    this.oldCompanyAdd,
    this.oldCompanyLeavingDate,
    this.oldCompanyLeavingDate1,
    this.height,
    this.weight,
    this.waist,
    this.chest,
    this.identificationMark,
    this.empTypeID,
    this.designationId,
    this.designationCode,
    this.designationName,
    this.branchId,
    this.siteId,
    this.siteCode,
    this.siteName,
    this.access,
    this.isApproved,
    this.isDeleted,
    this.isLockedOut,
    this.bankDocs,
    this.aadhaarDocs,
  });

  factory PreRecruitmentByIdModel.fromJson(Map<String, dynamic> json) {
    return PreRecruitmentByIdModel(
      compId: json['compId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      mobilePIN: json['mobilePIN']?.toString() ?? '',
      altMobilePIN: json['altMobilePIN']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      firstName: json['firstName']?. toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      statusId: json['statusId']?.toString() ?? '',
      currentAddress: json['currentAddress']?.toString() ?? '',
      currentPin: json['currentPin']?.toString() ?? '',
      currentStateId: json['currentStateId']?.toString() ?? '',
      currentCityId: json['currentCityId']?.toString() ?? '',
      currentPoliceStation: json['currentPoliceStation']?.toString() ?? '',
      currentPostOffice: json['currentPostOffice']?.toString() ?? '',
      permanentPin: json['permanentPin']?.toString() ?? '',
      permanentStateId: json['permanentStateId']?.toString() ?? '',
      permanentCityId: json['permanentCityId']?.toString() ?? '',
      permanentPoliceStation: json['permanentPoliceStation']?.toString() ?? '',
      permanentPostOffice: json['permanentPostOffice']?.toString() ?? '',
      permanentAddress: json['permanentAddress']?.toString() ?? '',
      pan: json['pan']?.toString() ?? '',
      aadharNum: json['aadharNum']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      placeOfBirth: json['placeOfBirth']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      motherName: json['motherName']?.toString() ?? '',
      createDate: json['createDate']?.toString() ?? '',
      signature: json['signature']?.toString() ?? '',
      emergencyEmail1: json['emergencyEmail1']?.toString() ?? '',
      emergencyName1: json['emergencyName1']?.toString() ?? '',
      emergencyContactDetails1: json['emergencyContactDetails1']?.toString() ?? '',
      emergencyContactReferenceDetails1: json['emergencyContactReferenceDetails1']?.toString() ?? '',
      bloodGroup: json['bloodGroup']?.toString() ?? '',
      bankId: json['bankId']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      enteredBankName: json['enteredBankName']?.toString() ?? '',
      accountHolderName: json['accountHolderName']?.toString() ?? '',
      accntNo: json['accntNo']?.toString() ?? '',
      ifscCode: json['ifscCode']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      pfNo: json['pfNo']?.toString() ?? '',
      esicNo: json['esicNo']?.toString() ?? '',
      uanNo: json['uanNo']?.toString() ?? '',
      doj: json['doj']?.toString() ?? '',
      marritalStatus: json['marritalStatus']?.toString() ?? '',
      spouseName: json['spouseName']?.toString() ?? '',
      spouseAge: json['spouseAge']?.toString() ?? '',
      nomineeName: json['nomineeName']?.toString() ?? '',
      nomineeAge: json['nomineeAge']?.toString() ?? '',
      nomineeRelation: json['nomineeRelation']?.toString() ?? '',
      oldCompany: json['oldCompany']?.toString() ?? '',
      oldDesignation: json['oldDesignation']?.toString() ?? '',
      oldExperience: json['oldExperience']?.toString() ?? '',
      oldCompanyAdd: json['oldCompanyAdd']?.toString() ?? '',
      oldCompanyLeavingDate: json['oldCompanyLeavingDate']?.toString() ?? '',
      oldCompanyLeavingDate1: json['oldCompanyLeavingDate1']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      waist: json['waist']?.toString() ?? '',
      chest: json['chest']?.toString() ?? '',
      identificationMark: json['identificationMark']?.toString() ?? '',
      empTypeID: json['empTypeID']?.toString() ?? '',
      designationId: json['designationId']?.toString() ?? '',
      designationCode: json['designationCode']?.toString() ?? '',
      designationName: json['designationName']?.toString() ?? '',
      branchId: json['branchId']?.toString() ?? '',
      siteId: json['siteId']?.toString() ?? '',
      siteCode: json['siteCode']?.toString() ?? '',
      siteName: json['siteName']?.toString() ?? '',
      access: json['access']?.toString() ?? '',
      isApproved: json['isApproved']?.toString() ?? '',
      isDeleted: json['isDeleted']?.toString() ?? '',
      isLockedOut: json['isLockedOut']?.toString() ?? '',
      bankDocs: json['bankDocs']?.toString() ?? '',
      aadhaarDocs: json['aadhaarDocs']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compId': compId,
      'userId': userId,
      'mobilePIN': mobilePIN,
      'altMobilePIN': altMobilePIN,
      'employeeCode': employeeCode,
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'statusId': statusId,
      'currentAddress': currentAddress,
      'currentPin': currentPin,
      'currentStateId': currentStateId,
      'currentCityId': currentCityId,
      'currentPoliceStation': currentPoliceStation,
      'currentPostOffice': currentPostOffice,
      'permanentPin': permanentPin,
      'permanentStateId': permanentStateId,
      'permanentCityId': permanentCityId,
      'permanentPoliceStation': permanentPoliceStation,
      'permanentPostOffice': permanentPostOffice,
      'permanentAddress': permanentAddress,
      'pan': pan,
      'aadharNum': aadharNum,
      'gender': gender,
      'dob': dob,
      'placeOfBirth': placeOfBirth,
      'image': image,
      'fatherName': fatherName,
      'motherName': motherName,
      'createDate': createDate,
      'signature': signature,
      'emergencyEmail1': emergencyEmail1,
      'emergencyName1': emergencyName1,
      'emergencyContactDetails1': emergencyContactDetails1,
      'emergencyContactReferenceDetails1': emergencyContactReferenceDetails1,
      'bloodGroup': bloodGroup,
      'bankId': bankId,
      'bankName': bankName,
      'enteredBankName': enteredBankName,
      'accountHolderName': accountHolderName,
      'accntNo': accntNo,
      'ifscCode': ifscCode,
      'branch': branch,
      'pfNo': pfNo,
      'esicNo': esicNo,
      'uanNo': uanNo,
      'doj': doj,
      'marritalStatus': marritalStatus,
      'spouseName': spouseName,
      'spouseAge': spouseAge,
      'nomineeName': nomineeName,
      'nomineeAge': nomineeAge,
      'nomineeRelation': nomineeRelation,
      'oldCompany': oldCompany,
      'oldDesignation': oldDesignation,
      'oldExperience': oldExperience,
      'oldCompanyAdd': oldCompanyAdd,
      'oldCompanyLeavingDate': oldCompanyLeavingDate,
      'oldCompanyLeavingDate1': oldCompanyLeavingDate1,
      'height': height,
      'weight': weight,
      'waist': waist,
      'chest': chest,
      'identificationMark': identificationMark,
      'empTypeID': empTypeID,
      'designationId': designationId,
      'designationCode': designationCode,
      'designationName': designationName,
      'branchId': branchId,
      'siteId': siteId,
      'siteCode': siteCode,
      'siteName': siteName,
      'access': access,
      'isApproved': isApproved,
      'isDeleted': isDeleted,
      'isLockedOut': isLockedOut,
      'bankDocs': bankDocs,
      'aadhaarDocs': aadhaarDocs,
    };
  }
}

class PreRecruitmentByIdResponse {
  List<PreRecruitmentByIdModel> table;

  PreRecruitmentByIdResponse({
    required this.table,
  });

  factory PreRecruitmentByIdResponse.fromJson(Map<String, dynamic> json) {
    return PreRecruitmentByIdResponse(
      table: (json['table'] as List<dynamic>?)
              ?.map((e) =>
                  PreRecruitmentByIdModel.fromJson(e as Map<String, dynamic>))
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
