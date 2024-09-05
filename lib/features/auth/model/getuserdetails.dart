class GetUserDetails {
  int? code;
  String? status;
  String? message;
  int? entityId;
  String? userId;
  String? role;
  String? userName;
  String? password;
  String? scheme;
  String? retailerType;
  int? parentID;
  String? name;
  String? postalAddress;
  int? cityID;
  int? stateID;
  String? districtName;
  String? stateName;
  String? pinCode;
  String? landLineNo;
  String? mobile;
  String? email;
  String? panNo;
  String? userProfilePic;
  int? compId;
  int? branchId;
  String? createdBy;
  String? modifiedBy;
  bool? isApproved;
  bool? isVisible;
  String? department;
  String? compCode;
  String? compName;
  String? access;
  String? designationName;
  String? employeeCode;
  String? userLoginRole;
  bool? isAutoCheckIn;
  String? interval;
  String? checkInT;
  String? checkOutT;
  String? companyContactNo;
  String? companyAddress;
  String? helplineNo;
  String? helpLineWhatsapp;

  GetUserDetails(
      {this.code,
      this.status,
      this.message,
      this.entityId,
      required this.userId,
      this.role,
      this.userName,
      this.password,
      this.scheme,
      this.retailerType,
      this.parentID,
      this.name,
      this.postalAddress,
      this.cityID,
      this.stateID,
      this.districtName,
      this.stateName,
      this.pinCode,
      this.landLineNo,
      this.mobile,
      this.email,
      this.panNo,
      this.userProfilePic,
      this.compId,
      this.branchId,
      this.createdBy,
      this.modifiedBy,
      this.isApproved,
      this.isVisible,
      this.department,
      this.compCode,
      this.compName,
      this.access,
      this.designationName,
      this.employeeCode,
      this.userLoginRole,
      this.isAutoCheckIn,
      this.interval,
      this.checkInT,
      this.checkOutT,
      this.companyContactNo,
      this.companyAddress,
      this.helplineNo,
      this.helpLineWhatsapp});

  GetUserDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    entityId = json['entityId'];
    userId = json['userId'];
    role = json['role'];
    userName = json['userName'];
    password = json['password'];
    scheme = json['scheme'];
    retailerType = json['retailerType'];
    parentID = json['parentID'];
    name = json['name'];
    postalAddress = json['postalAddress'];
    cityID = json['cityID'];
    stateID = json['stateID'];
    districtName = json['districtName'];
    stateName = json['stateName'];
    pinCode = json['pinCode'];
    landLineNo = json['landLineNo'];
    mobile = json['mobile'];
    email = json['email'];
    panNo = json['panNo'];
    userProfilePic = json['userProfilePic'];
    compId = json['compId'];
    branchId = json['branchId'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    isApproved = json['isApproved'];
    isVisible = json['isVisible'];
    department = json['department'];
    compCode = json['compCode'];
    compName = json['compName'];
    access = json['access'];
    designationName = json['designationName'];
    employeeCode = json['employeeCode'];
    userLoginRole = json['userLoginRole'];
    isAutoCheckIn = json['isAutoCheckIn'];
    interval = json['interval'];
    checkInT = json['checkInT'];
    checkOutT = json['checkOutT'];
    companyContactNo = json['companyContactNo'];
    companyAddress = json['companyAddress'];
    helplineNo = json['helplineNo'];
    helpLineWhatsapp = json['helpLineWhatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    data['entityId'] = this.entityId;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['scheme'] = this.scheme;
    data['retailerType'] = this.retailerType;
    data['parentID'] = this.parentID;
    data['name'] = this.name;
    data['postalAddress'] = this.postalAddress;
    data['cityID'] = this.cityID;
    data['stateID'] = this.stateID;
    data['districtName'] = this.districtName;
    data['stateName'] = this.stateName;
    data['pinCode'] = this.pinCode;
    data['landLineNo'] = this.landLineNo;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['panNo'] = this.panNo;
    data['userProfilePic'] = this.userProfilePic;
    data['compId'] = this.compId;
    data['branchId'] = this.branchId;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['isApproved'] = this.isApproved;
    data['isVisible'] = this.isVisible;
    data['department'] = this.department;
    data['compCode'] = this.compCode;
    data['compName'] = this.compName;
    data['access'] = this.access;
    data['designationName'] = this.designationName;
    data['employeeCode'] = this.employeeCode;
    data['userLoginRole'] = this.userLoginRole;
    data['isAutoCheckIn'] = this.isAutoCheckIn;
    data['interval'] = this.interval;
    data['checkInT'] = this.checkInT;
    data['checkOutT'] = this.checkOutT;
    data['companyContactNo'] = this.companyContactNo;
    data['companyAddress'] = this.companyAddress;
    data['helplineNo'] = this.helplineNo;
    data['helpLineWhatsapp'] = this.helpLineWhatsapp;
    return data;
  }
}
