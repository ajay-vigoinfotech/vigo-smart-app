import 'package:dio/dio.dart';
import '../../../core/constants/constants.dart';
import '../model/login_model.dart';

class LoginViewModel {
  final Dio _dio = Dio();

  Future<bool> makeRequest(LoginRequest request) async {
    const uri = '${AppConstants.baseUrl}/token';

    try {
      final response = await _dio.post(
        uri,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: request.toMap(),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.data}');
        return true;

      } else {
        // Handle unsuccessful response
        //print('Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      //print('Exception: $e');
      return false;
    }
  }
}

