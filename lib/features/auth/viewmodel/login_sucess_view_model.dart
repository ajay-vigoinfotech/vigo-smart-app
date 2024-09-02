import 'package:dio/dio.dart';
import '../../../core/constants/constants.dart';
import '../model/marklogin_model.dart';

class MarkLoginViewModel {
  final Dio _dio = Dio();

  Future<Object> markLogin(String token, MarkLoginModel markLoginModel) async {
    const uri = '${AppConstants.baseUrl}/API/CheckIns/MarkLogin';
    try {
      final response = await _dio.post(
        uri,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: markLoginModel.toMap()
      );

      print(response);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error: ${response.statusCode}');
        print('Response data: ${response.data}');
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.response?.statusCode}');
        print('DioException Data: ${e.response?.data}');
        print('DioException Headers: ${e.response?.headers}');
      } else {
        print('Exception: $e');
      }
      return e.toString();
    }
  }
}
