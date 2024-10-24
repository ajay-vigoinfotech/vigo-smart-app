import 'package:dio/dio.dart';
import '../../../core/constants/constants.dart';
import '../model/login_model.dart';
import '../model/token_model.dart';
import '../session_manager/session_manager.dart';

class LoginViewModel {
  final Dio _dio = Dio();
  final SessionManager sessionManager = SessionManager();
  String? _accessToken;

  Future<bool> makeRequest(LoginRequest request) async {
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
        _accessToken = sessionManager.getToken() as String?;
        return true;
      } else {
        // Handle the case when the response is not 200
        print('Error: Received status code ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.data is Map<String, dynamic>) {
          final errorDescription = e.response!.data['error_description'];
          print('Error: $errorDescription'); // Print error description
        } else {
          print('Unexpected Dio error: $e'); // Handle Dio-related errors
        }
      } else {
        print('General exception: $e'); // Handle general exceptions
      }
      return false;
    }
  }
}
