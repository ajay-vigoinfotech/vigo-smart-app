class PreviousSiteReportingListModel {
  String? title;
  String? answer;
  String? comment;
  String? employeeCode;
  String? fullname;
  String? mobileNo;
  String? designationName;
  String? checkinId;
  String? latLong;
  String? location;
  String? checkintypename;
  String? datetime;
  String? inRemarks;
  String? dateTimeIn;
  String? dateTimeOut;
  String? unitname;
  String? unitaddress;
  String? siteEmailId;
  String? clientName;
  String? branchName;
  String? compEmail;

  PreviousSiteReportingListModel({
    required this.title,
    required this.answer,
    required this.comment,
    required this.employeeCode,
    required this.fullname,
    required this.mobileNo,
    required this.designationName,
    required this.checkinId,
    required this.latLong,
    required this.location,
    required this.checkintypename,
    required this.datetime,
    required this.inRemarks,
    required this.dateTimeIn,
    required this.dateTimeOut,
    required this.unitname,
    required this.unitaddress,
    required this.siteEmailId,
    required this.clientName,
    required this.branchName,
    required this.compEmail,
  });

  factory PreviousSiteReportingListModel.fromJson(Map<String, dynamic> json) {
    return PreviousSiteReportingListModel(
      title: json['title']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      fullname: json['fullname']?.toString() ?? '',
      mobileNo: json['mobileNo']?.toString() ?? '',
      designationName: json['designationName']?.toString() ?? '',
      checkinId: json['checkinId']?.toString() ?? '',
      latLong: json['latLong']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      checkintypename: json['checkintypename']?.toString() ?? '',
      datetime: json['datetime']?.toString() ?? '',
      inRemarks: json['inRemarks']?.toString() ?? '',
      dateTimeIn:json['dateTimeIn']?.toString() ?? '',
      dateTimeOut: json['dateTimeOut']?.toString() ?? '',
      unitname: json['unitname']?.toString() ?? '',
      unitaddress: json['unitaddress']?.toString() ?? '',
      siteEmailId: json['siteEmailId']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      branchName: json['branchName']?.toString() ?? '',
      compEmail: json['compEmail']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title' : title,
      'answer' : answer,
      'comment' : comment,
      'employeeCode' : employeeCode,
      'fullname' : fullname,
      'mobileNo' : mobileNo,
      'designationName' : designationName,
      'checkinId' : checkinId,
      'latLong' : latLong,
      'location' : location,
      'checkintypename' : checkintypename,
      'datetime' : datetime,
      'inRemarks' : inRemarks,
      'dateTimeIn' : dateTimeIn,
      'dateTimeOut' : dateTimeOut,
      'unitname' : unitname,
      'unitaddress' : unitaddress,
      'siteEmailId' : siteEmailId,
      'clientName' : clientName,
      'branchName' : branchName,
      'compEmail' : compEmail,
    };
  }
}

class PreviousSiteReportingListResponse{
  List<PreviousSiteReportingListModel> table;

  PreviousSiteReportingListResponse({
    required this.table,
});

  factory PreviousSiteReportingListResponse.fromJson(Map<String, dynamic> json) {
    return PreviousSiteReportingListResponse(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) =>
          PreviousSiteReportingListModel.fromJson(e as Map<String, dynamic>))
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






