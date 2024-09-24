class CheckSessionModel {
  int? code;
  String? status;
  String? message;
  String? data;

  CheckSessionModel({this.code, this.status, this.message, this.data});

  CheckSessionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
