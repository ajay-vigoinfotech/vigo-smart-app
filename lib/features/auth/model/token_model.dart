class TokenModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  TokenModel({this.accessToken, this.tokenType, this.expiresIn});

  TokenModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}

