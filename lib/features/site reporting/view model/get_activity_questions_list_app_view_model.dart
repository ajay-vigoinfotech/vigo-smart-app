import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/site%20reporting/model/get_activity_questions_list_app_model.dart';

class GetActivityQuestionsListAppViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<GetActivityQuestionsListAppModel>? getActivityQuestionsListCount;

  Future<void> fetchGetActivityQuestionsList(String token) async {
    const url = "${AppConstants.baseUrl}/API/SiteVisit/GetActivityQuestionsListApp";

    try{
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        )
      );

      if (response.statusCode == 200) {
        final responseData = GetActivityQuestionsListAppResponse.fromJson(response.data);

        if(responseData.table.isNotEmpty) {
          getActivityQuestionsListCount = responseData.table;
          //debugPrint('$response');
        } else {
          debugPrint('Table is Empty');
        }
      } else {
        debugPrint('Error :: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error:: ${e.message}');
    } catch (e) {
      debugPrint('$e');
    }
  }
}
