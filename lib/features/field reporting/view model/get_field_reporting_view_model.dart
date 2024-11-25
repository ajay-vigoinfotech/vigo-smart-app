import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

import '../model/get_field_reporting_model.dart';

class GetFieldReportingViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<GetFieldReportingModel>? getFieldReportingList;

  Future<void> fetchGetFieldReportingList(String token) async {
    const url = '${AppConstants.baseUrl}/API/Kotlin/GetFieldReporting';
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = GetFieldReportingResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          getFieldReportingList = responseData.table;
          //debugPrint('$response');
        } else {
          debugPrint('teamActivityAttendanceList is empty');
        }
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
