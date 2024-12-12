import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

class LeaveCancelViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();

  Future<void> markLeaveCancel(String token) async {
    const url = "${AppConstants.baseUrl}/API/Payroll/CancelEmpLeave";

    try {
      final response = await _dio.post(url,
          options: Options(
              headers: {'Authorization': 'Bearer $token'},
              contentType: Headers.formUrlEncodedContentType),
          data: {});

      if (response.statusCode == 200) {
        debugPrint('$response');
      } else {
        debugPrint(
            'Error :: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error ${e.message}');
    } catch (e) {
      debugPrint('$e');
    }
  }
}
