class MarkLoginResponse {
  final String message;

  MarkLoginResponse({required this.message});

  factory MarkLoginResponse.fromJson(Map<String, dynamic> json) {
    return MarkLoginResponse(
      message: json['message'],
    );
  }
}
