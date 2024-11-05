class SelfieAttendanceModel {
  List<AttendanceTable>? table;
  List<HttpResponseStatus>? httpResponseStatus;

  SelfieAttendanceModel({this.table, this.httpResponseStatus});

  SelfieAttendanceModel.fromJson(Map<String, dynamic> json) {
    table = (json['table'] as List?)?.map((v) => AttendanceTable.fromJson(v)).toList();
    httpResponseStatus = (json['httpResponseStatus'] as List?)?.map((v) => HttpResponseStatus.fromJson(v)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table?.map((v) => v.toJson()).toList(),
      'httpResponseStatus': httpResponseStatus?.map((v) => v.toJson()).toList(),
    };
  }
}

class AttendanceTable {
  String uniqueId;
  String dateTimeIn;
  String dateTimeOut;
  String inKmsDriven;
  String outKmsDriven;
  String siteId;
  String siteName;

  AttendanceTable({
    this.uniqueId = "",
    this.dateTimeIn = "",
    this.dateTimeOut = "",
    this.inKmsDriven = "",
    this.outKmsDriven = "",
    this.siteId = "",
    this.siteName = "",
  });

  AttendanceTable.fromJson(Map<String, dynamic> json)
      : uniqueId = json['uniqueId']?.toString() ?? "",
        dateTimeIn = json['dateTimeIn']?.toString() ?? "",
        dateTimeOut = json['dateTimeOut']?.toString() ?? "",
        inKmsDriven = json['inKmsDriven']?.toString() ?? "",
        outKmsDriven = json['outKmsDriven']?.toString() ?? "",
        siteId = json['siteId']?.toString() ?? "",
        siteName = json['siteName']?.toString() ?? "";

  Map<String, dynamic> toJson() {
    return {
      'uniqueId': uniqueId,
      'dateTimeIn': dateTimeIn,
      'dateTimeOut': dateTimeOut,
      'inKmsDriven': inKmsDriven,
      'outKmsDriven': outKmsDriven,
      'siteId': siteId,
      'siteName': siteName,
    };
  }
}

class HttpResponseStatus {
  int? code;
  String? status;
  String? message;

  HttpResponseStatus({this.code, this.status, this.message});

  HttpResponseStatus.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        status = json['status'],
        message = json['message'];

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
    };
  }
}
