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
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    data['entityId'] = entityId;
    data['userId'] = userId;
    data['role'] = role;
    data['userName'] = userName;
    data['password'] = password;
    data['scheme'] = scheme;
    data['retailerType'] = retailerType;
    data['parentID'] = parentID;
    data['name'] = name;
    data['postalAddress'] = postalAddress;
    data['cityID'] = cityID;
    data['stateID'] = stateID;
    data['districtName'] = districtName;
    data['stateName'] = stateName;
    data['pinCode'] = pinCode;
    data['landLineNo'] = landLineNo;
    data['mobile'] = mobile;
    data['email'] = email;
    data['panNo'] = panNo;
    data['userProfilePic'] = userProfilePic;
    data['compId'] = compId;
    data['branchId'] = branchId;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['isApproved'] = isApproved;
    data['isVisible'] = isVisible;
    data['department'] = department;
    data['compCode'] = compCode;
    data['compName'] = compName;
    data['access'] = access;
    data['designationName'] = designationName;
    data['employeeCode'] = employeeCode;
    data['userLoginRole'] = userLoginRole;
    data['isAutoCheckIn'] = isAutoCheckIn;
    data['interval'] = interval;
    data['checkInT'] = checkInT;
    data['checkOutT'] = checkOutT;
    data['companyContactNo'] = companyContactNo;
    data['companyAddress'] = companyAddress;
    data['helplineNo'] = helplineNo;
    data['helpLineWhatsapp'] = helpLineWhatsapp;
    return data;
  }
}
