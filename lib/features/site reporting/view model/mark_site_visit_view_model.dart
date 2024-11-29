import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/mark_site_visit_model.dart';

class MarkSiteVisitViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();

  Future<Map<String, Object?>> markMarkSiteVisit(
      String token, MarkSiteVisitModel markSiteVisitModel) async {
    const url = "${AppConstants.baseUrl}/API/SiteVisit/MarkSiteVisit";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: markSiteVisitModel.toJson(),
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
