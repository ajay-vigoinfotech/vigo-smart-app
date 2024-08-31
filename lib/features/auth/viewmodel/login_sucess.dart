import 'package:dio/dio.dart';
import '../../../core/constants/constants.dart';
import '../model/marklogin.dart';

class MarkLoginViewModel {
  final Dio _dio = Dio();

  Future<MarkLoginResponse?> markLogin(String token) async {
    const uri = '${AppConstants.baseUrl}/API/CheckIns/MarkLogin';
    try {
      Response response = await _dio.post(
        uri,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
        },
      );

      if (response.statusCode == 200) {
        return MarkLoginResponse.fromJson(response.data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
