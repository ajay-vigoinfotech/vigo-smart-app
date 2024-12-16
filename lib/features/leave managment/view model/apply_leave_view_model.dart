import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

import '../model/apply_leave_model.dart';

class ApplyLeaveViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();

  Future<Map<String, Object?>> markApplyLeave(
      String token, ApplyLeaveModel applyLeaveModel) async {
    const url = "${AppConstants.baseUrl}/API/Payroll/SubmitEmployeeLeaveApp";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: applyLeaveModel.toJson(),
      );

      if (response.statusCode == 200) {
        debugPrint('$response');
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'code': response.statusCode,
          'status': 'Error: ${response.statusMessage}'
        };
      }
    } catch (e) {
      if (e is DioException) {
        return {
          'code': 500,
          'status': 'Error occurred: ${e.response?.data ?? e.message}'
        };
      }
      return {'code': 500, 'status': 'Unexpected error: $e'};
    }
  }
}
