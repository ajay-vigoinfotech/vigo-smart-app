class SelfieAttendanceModel {
  List<Table>? table;
  List<HttpResponseStatus>? httpResponseStatus;

  SelfieAttendanceModel({this.table, this.httpResponseStatus});

  SelfieAttendanceModel.fromJson(Map<String, dynamic> json) {
    if (json['table'] != null) {
      table = <Table>[];
      json['table'].forEach((v) {
        table!.add(Table.fromJson(v));
      });
    }
    if (json['httpResponseStatus'] != null) {
      httpResponseStatus = <HttpResponseStatus>[];
      json['httpResponseStatus'].forEach((v) {
        httpResponseStatus!.add(HttpResponseStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (table != null) {
      data['table'] = table!.map((v) => v.toJson()).toList();
    }
    if (httpResponseStatus != null) {
      data['httpResponseStatus'] =
          httpResponseStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table {
  String? checkinId;
  String? uniqueId;
  String? dateTimeIn;
  String? dateTimeOut;
  String? inKmsDriven;
  String? outKmsDriven;
  String? siteId;
  String? siteName;

  Table(
      {this.checkinId,
      this.uniqueId,
      this.dateTimeIn,
      this.dateTimeOut,
      this.inKmsDriven,
      this.outKmsDriven,
      this.siteId,
      this.siteName});

  Table.fromJson(Map<String, dynamic> json) {
    checkinId = json['checkinId'].toString();
    uniqueId = json['uniqueId'].toString();
    dateTimeIn = json['dateTimeIn'].toString();
    dateTimeOut = json['dateTimeOut'].toString();
    inKmsDriven = json['inKmsDriven'].toString();
    outKmsDriven = json['outKmsDriven'].toString();
    siteId = json['siteId'].toString();
    siteName = json['siteName'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkinId'] = checkinId;
    data['uniqueId'] = uniqueId;
    data['dateTimeIn'] = dateTimeIn;
    data['dateTimeOut'] = dateTimeOut;
    data['inKmsDriven'] = inKmsDriven;
    data['outKmsDriven'] = outKmsDriven;
    data['siteId'] = siteId;
    data['siteName'] = siteName;
    return data;
  }
}

class HttpResponseStatus {
  int? code;
  String? status;
  String? message;

  HttpResponseStatus({this.code, this.status, this.message});

  HttpResponseStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
