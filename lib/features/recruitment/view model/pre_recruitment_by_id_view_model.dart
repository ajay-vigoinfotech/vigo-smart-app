import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

import '../model/pre_recruitment_by_id_model.dart';

class PreRecruitmentByIdViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<PreRecruitmentByIdModel>? getPreRecruitmentByIdList;

  Future<void> fetchPreRecruitmentByIdList(String token, String userId) async {
    const url = '${AppConstants.baseUrl}/API/ManageUser/GetPreRecruitmentByIdApp';
    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'EmployeeId': userId },
      );

      if (response.statusCode == 200) {
        final responseData = PreRecruitmentByIdResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          getPreRecruitmentByIdList = responseData.table;
          debugPrint('$response');
        } else {
          debugPrint('getPreRecruitmentByIdList is empty');
        }
      } else {
        debugPrint('Error :: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error ${e.message}');
    } catch (e) {
      debugPrint('$e');
    }
  }
}
