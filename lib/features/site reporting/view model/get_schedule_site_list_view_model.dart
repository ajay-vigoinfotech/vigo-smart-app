import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

import '../model/get_schedule_site_list_model.dart';

class GetScheduleSiteListViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<GetScheduleSiteListModel>? getScheduleSiteList;

  Future<void> fetchGetScheduleSiteListData(String token, String formattedDate) async {
    const url = "${AppConstants.baseUrl}/API/Unit/GetSiteSchedulingByUserId";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'Date': formattedDate},
      );

      if (response.statusCode == 200) {
        final responseData = GetScheduleSiteListResponse.fromJson(response.data);
        if (responseData.table.isNotEmpty) {
          getScheduleSiteList = responseData.table;
          debugPrint('$response');
        } else {
          debugPrint('GetScheduleSiteListResponse is empty');
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
