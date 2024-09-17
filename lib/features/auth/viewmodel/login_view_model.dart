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
        String getToken = sessionManager.getToken().toString();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      print('Exception: $e');
      return false;
    }
  }
}
