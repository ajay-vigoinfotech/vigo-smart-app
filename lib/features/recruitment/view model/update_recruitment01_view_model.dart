import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/update_recruitment01_model.dart';

class UpdateRecruitment01ViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();

  Future<Map<String, dynamic>> updateRecruitment01(String token, UpdateRecruitment01Model updateRecruitment01Model) async {
    const url = "${AppConstants.baseUrl}/API/ManageUser/UpdateRecruitmentApp01";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: updateRecruitment01Model.toJson(),
      );

      if (response.statusCode == 200) {
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
