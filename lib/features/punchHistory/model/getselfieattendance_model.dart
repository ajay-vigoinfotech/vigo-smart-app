class GetSelfieAttendanceModel {
  List<SelfieAttendanceTable>? table;
  List<HttpResponseStatus>? httpResponseStatus;

  GetSelfieAttendanceModel({this.table, this.httpResponseStatus});

  GetSelfieAttendanceModel.fromJson(Map<String, dynamic> json) {
    if (json['table'] != null) {
      table = <SelfieAttendanceTable>[];
      json['table'].forEach((v) {
        table!.add(SelfieAttendanceTable.fromJson(v));
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

class SelfieAttendanceTable {
  String? compId;
  String? dateTimeIn;
  String? dateTimeOut;
  String? totalHours;
  String? location;
  String? outLocation;
  String? inRemarks;
  String? inPhoto;
  String? outPhoto;
  String? outRemarks;
  String? inKmsDriven;
  String? outKmsDriven;

  SelfieAttendanceTable({
    this.compId,
    this.dateTimeIn,
    this.dateTimeOut,
    this.totalHours,
    this.location,
    this.outLocation,
    this.inRemarks,
    this.inPhoto,
    this.outPhoto,
    this.outRemarks,
    this.inKmsDriven,
    this.outKmsDriven,
  });

  SelfieAttendanceTable.fromJson(Map<String, dynamic> json) {
    compId = json['compId']?.toString() ?? "Not marked yet";
    dateTimeIn = json['dateTimeIn']?.toString() ?? "Not marked yet";
    dateTimeOut = json['dateTimeOut']?.toString() ?? "Not marked yet";
    totalHours = json['totalHours']?.toString() ?? "Not marked yet";
    location = json['location']?.toString() ?? "";
    outLocation = json['outLocation']?.toString() ?? "";
    inRemarks = json['inRemarks']?.toString() ?? "";
    inPhoto = json['inPhoto']?.toString() ?? "";
    outPhoto = json['outPhoto']?.toString() ?? "";
    outRemarks = json['outRemarks']?.toString() ?? "";
    inKmsDriven = json['inKmsDriven']?.toString() ?? "";
    outKmsDriven = json['outKmsDriven']?.toString() ?? "";
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, String>{};
    data['compId'] = compId;
    data['dateTimeIn'] = dateTimeIn;
    data['dateTimeOut'] = dateTimeOut;
    data['totalHours'] = totalHours;
    data['location'] = location;
    data['outLocation'] = outLocation;
    data['inRemarks'] = inRemarks;
    data['inPhoto'] = inPhoto;
    data['outPhoto'] = outPhoto;
    data['outRemarks'] = outRemarks;
    data['inKmsDriven'] = inKmsDriven;
    data['outKmsDriven'] = outKmsDriven;
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
