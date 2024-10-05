import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/constants.dart';
import '../model/marklogin_model.dart';

class MarkLoginViewModel {
  final Dio _dio = Dio();

  Future<Object> markLogin(String token, MarkLoginModel markLoginModel) async {
    const url = '${AppConstants.baseUrl}/API/CheckIns/MarkLogin';
    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: markLoginModel.toMap()
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response data: ${response.data}');
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('DioException: ${e.response?.statusCode}');
        debugPrint('DioException Data: ${e.response?.data}');
        debugPrint('DioException Headers: ${e.response?.headers}');
      } else {
        debugPrint('Exception: $e');
      }
      return e.toString();
    }
  }
}
