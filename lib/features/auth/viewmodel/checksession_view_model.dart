import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/constants.dart';
import '../model/checksession_model.dart';

class CheckSessionViewModel {
  final Dio _dio = Dio();

  Future<int?> checkSession(String token, CheckSessionModel checkSessionModel) async {
    const url = '${AppConstants.baseUrl}/API/Kotlin/CheckSession';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: checkSessionModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Return the status code directly as an int
        return response.statusCode;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return response.statusCode; // Return the error status code as an int
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return null; // Return null if there's an exception
    }
  }
}
