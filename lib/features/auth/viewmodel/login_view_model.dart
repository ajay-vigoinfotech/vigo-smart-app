import 'package:dio/dio.dart';
import '../../../core/constants/constants.dart';
import '../model/login_model.dart';
import '../model/token_model.dart';
import '../session_manager/session_manager.dart';

class LoginViewModel {
  final Dio _dio = Dio();
  final SessionManager sessionManager = SessionManager();
  String? _accessToken;

  Future makeRequest(LoginRequest request) async {
    const url = '${AppConstants.baseUrl}/token';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: request.toMap(),
      );

      if (response.statusCode == 200) {
        final token = TokenModel.fromJson(response.data);
        await sessionManager.saveToken(token.accessToken.toString());
        _accessToken = await sessionManager.getToken();
        return null;
      } else {
        return 'Error: Received status code ${response.statusCode}';
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.data is Map<String, dynamic>) {
          final errorDescription = e.response!.data['error_description'];
          return errorDescription ?? 'Login failed due to an unknown error';
        } else {
          return 'Unexpected error occurred: $e';
        }
      } else {
        return 'General exception: $e';
      }
    }
  }
}
