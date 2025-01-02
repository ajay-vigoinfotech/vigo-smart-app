import 'package:dio/dio.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/create_recruitment_model.dart';
import '../../../core/constants/constants.dart';

class CreateRecruitmentViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();


  Future<Map<String, dynamic>> createRecruitment(String token, CreateRecruitmentModel createRecruitmentModel) async {
    const url = '${AppConstants.baseUrl}/API/ManageUser/CreateRecruitmentApp';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: createRecruitmentModel.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        return {'code': response.statusCode, 'status': 'Error: ${response.statusMessage}'};
      }
    } catch (e) {
      if (e is DioException) {
        return {'code': 500, 'status': 'Error occurred: ${e.response?.data ?? e.message}'};
      }
      return {'code': 500, 'status': 'Unexpected error: $e'};
    }
  }
}