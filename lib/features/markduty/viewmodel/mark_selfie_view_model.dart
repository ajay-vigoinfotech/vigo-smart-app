import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import '../model/markselfieattendance_model.dart';

class MarkSelfieAttendance {
  final Dio _dio = Dio();

  Future<String> markAttendance(String token, PunchDetails punchDetails) async {
    const url = '${AppConstants.baseUrl}/API/Kotlin/MarkSelfieAttendance';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'okhttp/4.9.1',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: punchDetails.toJson(),
      );

      if (response.statusCode == 200) {
        debugPrint('${response.data}');
        return response.data.toString();
      } else {
        return 'Error: ${response.statusCode} - ${response.statusMessage}';
      }
    } catch (e) {
      if (e is DioException) {
        return 'Error occurred: ${e.response?.data ?? e.message}';
      }
      return 'Unexpected error: $e';
    }
  }
}
