class LoginRequest {
  final String grantType;
  final String username;
  final String password;

  LoginRequest({
    required this.grantType,
    required this.username,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      'grant_type': grantType,
      'username': username,
      'password': password,
    };
  }
}