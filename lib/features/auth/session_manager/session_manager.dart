import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigo_smart_app/features/auth/model/getuserdetails.dart';
import '../model/getlastselfieattendancemodel.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';
  static const String _accessToken = 'access_token';
  static const String _moduleCodesKey = 'module_codes';
  static const String _userDetailsKey = 'user_details';
  static const String _SelfieAttendanceKey = 'selfie_attendance';
  static const String _currentDateTimeKey = 'currentDateTime';
  static const String _supportContactKey = 'supportContact';
  static const String _checkSessionKey = 'checkSession';

  //save last selfie att strings
  static const String _checkinId = 'checkinId';
  static const String _uniqueId = 'uniqueId';
  static const String _dateTimeIn = 'dateTimeIn';
  static const String _dateTimeOut = 'dateTimeOut';
  static const String _inKmsDriven = 'inKmsDriven';
  static const String _outKmsDriven = 'outKmsDriven';
  static const String _siteId = 'siteId';
  static const String _siteName = 'siteName';

  //save user details strings
  static const String _code = 'code';
  static const String _status = 'status';
  static const String _message = 'message';
  static const String _entityIdKey = 'entity_id';
  static const String _userIdKey = 'user_id';
  static const String _roleKey = 'role';
  static const String _userNameKey = 'user_name';
  static const String _passwordKey = 'password';
  static const String _schemeKey = 'scheme';
  static const String _retailerTypeKey = 'retailer_type';
  static const String _parentIDKey = 'parent_id';
  static const String _nameKey = 'name';
  static const String _postalAddressKey = 'postal_address';
  static const String _cityIDKey = 'city_id';
  static const String _stateIDKey = 'state_id';
  static const String _districtNameKey = 'district_name';
  static const String _stateNameKey = 'state_name';
  static const String _pinCodeKey = 'pin_code';
  static const String _landLineNoKey = 'land_line_no';
  static const String _mobileKey = 'mobile';
  static const String _emailKey = 'email';
  static const String _panNoKey = 'pan_no';
  static const String _userProfilePicKey = 'user_profile_pic';
  static const String _compIdKey = 'comp_id';
  static const String _branchIdKey = 'branch_id';
  static const String _createdByKey = 'created_by';
  static const String _modifiedByKey = 'modified_by';
  static const String _isApprovedKey = 'is_approved';
  static const String _isVisibleKey = 'is_visible';
  static const String _departmentKey = 'department';
  static const String _compCodeKey = 'comp_code';
  static const String _compNameKey = 'comp_name';
  static const String _accessKey = 'access';
  static const String _designationNameKey = 'designation_name';
  static const String _employeeCodeKey = 'employee_code';
  static const String _userLoginRoleKey = 'user_login_role';
  static const String _isAutoCheckInKey = 'is_auto_check_in';
  static const String _intervalKey = 'interval';
  static const String _checkInTKey = 'check_in_time';
  static const String _checkOutTKey = 'check_out_time';
  static const String _companyContactNoKey = 'company_contact_no';
  static const String _companyAddressKey = 'company_address';
  static const String _helplineNoKey = 'helpline_no';
  static const String _helpLineWhatsappKey = 'help_line_whatsapp';

  //mark in & out
  static const String punchInImageKey = 'punch_in_image';
  static const String punchOutImageKey = 'punch_out_image';

  // Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, token);
  }

  // Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessToken);
  }

  // Save login info
  Future<void> saveLoginInfo(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_usernameKey, username);
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_accessToken);
  }

  // Save module codes
  Future<void> saveModuleCodes(List<String> moduleCodes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_moduleCodesKey, moduleCodes);
  }

  // Get module codes
  Future<List<String>?> getModuleCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_moduleCodesKey);
  }

  // Save user details
  Future<void> saveUserDetails(GetUserDetails user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_code, user.code as int);
    await prefs.setString(_status, user.status.toString());
    await prefs.setString(_message, user.message.toString());
    await prefs.setInt(_entityIdKey, user.entityId as int);
    await prefs.setString(_userIdKey, user.userId.toString());
    await prefs.setString(_roleKey, user.role.toString());
    await prefs.setString(_userNameKey, user.userName.toString());
    await prefs.setString(_passwordKey, user.password.toString());
    await prefs.setString(_schemeKey, user.scheme.toString());
    await prefs.setString(_retailerTypeKey, user.retailerType.toString());
    await prefs.setInt(_parentIDKey, user.parentID as int);
    await prefs.setString(_nameKey, user.name.toString());
    await prefs.setString(_postalAddressKey, user.postalAddress.toString());
    await prefs.setInt(_cityIDKey, user.cityID as int);
    await prefs.setInt(_stateIDKey, user.stateID as int);
    await prefs.setString(_districtNameKey, user.districtName.toString());
    await prefs.setString(_stateNameKey, user.stateName.toString());
    await prefs.setString(_pinCodeKey, user.pinCode.toString());
    await prefs.setString(_landLineNoKey, user.landLineNo.toString());
    await prefs.setString(_mobileKey, user.mobile.toString());
    await prefs.setString(_emailKey, user.email.toString());
    await prefs.setString(_panNoKey, user.panNo.toString());
    await prefs.setString(_userProfilePicKey, user.userProfilePic.toString());
    await prefs.setInt(_compIdKey, user.compId as int);
    await prefs.setInt(_branchIdKey, user.branchId as int);
    await prefs.setString(_createdByKey, user.createdBy.toString());
    await prefs.setString(_modifiedByKey, user.modifiedBy.toString());
    await prefs.setBool(_isApprovedKey, user.isApproved as bool);
    await prefs.setBool(_isVisibleKey, user.isVisible as bool);
    await prefs.setString(_departmentKey, user.designationName.toString());
    await prefs.setString(_compCodeKey, user.compCode.toString());
    await prefs.setString(_compNameKey, user.compName.toString());
    await prefs.setString(_accessKey, user.access.toString());
    await prefs.setString(_designationNameKey, user.designationName.toString());
    await prefs.setString(_employeeCodeKey, user.employeeCode.toString());
    await prefs.setString(_userLoginRoleKey, user.userLoginRole.toString());
    await prefs.setBool(_isAutoCheckInKey, user.isAutoCheckIn as bool);
    await prefs.setString(_intervalKey, user.interval.toString());
    await prefs.setString(_checkInTKey, user.checkInT.toString());
    await prefs.setString(_checkOutTKey, user.checkOutT.toString());
    await prefs.setString(
        _companyContactNoKey, user.companyContactNo.toString());
    await prefs.setString(_companyAddressKey, user.companyAddress.toString());
    await prefs.setString(_helplineNoKey, user.helplineNo.toString());
    await prefs.setString(
        _helpLineWhatsappKey, user.helpLineWhatsapp.toString());
  }

  // Get user details
  Future<GetUserDetails> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return GetUserDetails(
      code: prefs.getInt(_code),
      status: prefs.getString(_status),
      message: prefs.getString(_message),
      entityId: prefs.getInt(_entityIdKey),
      userId: prefs.getString(_userIdKey),
      role: prefs.getString(_roleKey),
      userName: prefs.getString(_usernameKey),
      password: prefs.getString(_passwordKey),
      scheme: prefs.getString(_schemeKey),
      retailerType: prefs.getString(_retailerTypeKey),
      parentID: prefs.getInt(_parentIDKey),
      name: prefs.getString(_nameKey),
      postalAddress: prefs.getString(_postalAddressKey),
      cityID: prefs.getInt(_cityIDKey),
      stateID: prefs.getInt(_stateIDKey),
      districtName: prefs.getString(_districtNameKey),
      stateName: prefs.getString(_stateNameKey),
      pinCode: prefs.getString(_pinCodeKey),
      landLineNo: prefs.getString(_landLineNoKey),
      mobile: prefs.getString(_mobileKey),
      email: prefs.getString(_emailKey),
      panNo: prefs.getString(_panNoKey),
      userProfilePic: prefs.getString(_usernameKey),
      compId: prefs.getInt(_compIdKey),
      branchId: prefs.getInt(_branchIdKey),
      createdBy: prefs.getString(_createdByKey),
      modifiedBy: prefs.getString(_modifiedByKey),
      isApproved: prefs.getBool(_isApprovedKey),
      isVisible: prefs.getBool(_isVisibleKey),
      department: prefs.getString(_departmentKey),
      compCode: prefs.getString(_compCodeKey),
      compName: prefs.getString(_compNameKey),
      access: prefs.getString(_accessKey),
      designationName: prefs.getString(_designationNameKey),
      employeeCode: prefs.getString(_employeeCodeKey),
      userLoginRole: prefs.getString(_userLoginRoleKey),
      isAutoCheckIn: prefs.getBool(_isAutoCheckInKey),
      interval: prefs.getString(_intervalKey),
      checkInT: prefs.getString(_checkInTKey),
      checkOutT: prefs.getString(_checkOutTKey),
      companyContactNo: prefs.getString(_companyContactNoKey),
      companyAddress: prefs.getString(_companyAddressKey),
      helplineNo: prefs.getString(_helplineNoKey),
      helpLineWhatsapp: prefs.getString(_helpLineWhatsappKey),
    );
  }

  //save SelfieAttendance
  Future<void> saveSelfieAttendance(
      SelfieAttendanceModel selfieAttendanceModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _uniqueId, selfieAttendanceModel.table![0].uniqueId.toString());
    await prefs.setString(
        _dateTimeIn, selfieAttendanceModel.table![0].dateTimeIn.toString());
    await prefs.setString(
        _dateTimeOut, selfieAttendanceModel.table![0].dateTimeOut.toString());
    await prefs.setString(
        _inKmsDriven, selfieAttendanceModel.table![0].inKmsDriven.toString());
    await prefs.setString(
        _outKmsDriven, selfieAttendanceModel.table![0].outKmsDriven.toString());
    await prefs.setString(
        _siteId, selfieAttendanceModel.table![0].siteId.toString());
    await prefs.setString(
        _siteName, selfieAttendanceModel.table![0].siteName.toString());
  }

  //Get SelfieAttendance
  Future<AttendanceTable> getCheckinData() async {
    final prefs = await SharedPreferences.getInstance();
    return AttendanceTable(
      uniqueId: prefs.getString(_uniqueId),
      dateTimeIn: prefs.getString(_dateTimeIn),
      dateTimeOut: prefs.getString(_dateTimeOut),
      inKmsDriven: prefs.getString(_inKmsDriven),
      outKmsDriven: prefs.getString(_outKmsDriven),
      siteId: prefs.getString(_siteId),
      siteName: prefs.getString(_siteName),
    );
  }

// Save Current DateTime
  Future<void> saveCurrentDateTime(String dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentDateTimeKey, dateTime);
  }

// Get saved DateTime
  Future<String?> getTimeDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentDateTimeKey);
  }

  // Save SupportContact
  Future<void> saveSupportContact(String contact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_supportContactKey, contact);
  }

  // Get SupportContact
  Future<String?> getStoredSupportContact() async {
    final prefs = await SharedPreferences.getInstance();
    final supportContact = prefs.getString(_supportContactKey);
    return supportContact;
  }

// Save punch-in image path to shared preferences
  Future<void> savePunchInPath(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('punchInImagePath', path);
  }

  // Save punch-in image path to shared preferences
  Future<void> savePunchOutPath(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savePunchOutPath', path);
  }

// Get punch-in image path from shared preferences
  Future<String?> getPunchInPath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('punchInImagePath');
  }
}
