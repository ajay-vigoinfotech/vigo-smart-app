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
        return response.statusCode;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return null;
    }
  }
}
