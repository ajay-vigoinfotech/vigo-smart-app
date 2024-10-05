import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';

class MarkSelfieAttendance {
  final Dio _dio = Dio();

  Future<String> markAttendance(String token) async {
    const url = '${AppConstants.baseUrl}/API/Kotlin/MarkSelfieAttendance';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'okhttp/4.9.1',
            'Content-Length': '0',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a message or success flag
        return 'Attendance marked successfully!';
      } else {
        return 'Failed to mark attendance. Status code: ${response.statusCode}';
      }
    } catch (e) {
      // Handling DioError or any general error
      if (e is DioException) {
        return 'Error occurred: ${e.response?.data ?? e.message}';
      }
      return 'Unexpected error: $e';
    }
  }
}
