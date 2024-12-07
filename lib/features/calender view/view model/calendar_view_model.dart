import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

import '../model/calendar_model.dart';

class CalendarViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<CalendarModel>? getCalendarResponseList;

  Future<void> fetchCalendarResponseList(String token) async {
    const url =
        "${AppConstants.baseUrl}/API/Duty/GetDateRangeWiseAbsentPresentChartKotlin";

    try {
      final response = await _dio.post(url,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            contentType: Headers.formUrlEncodedContentType,
          ),
          data: {'month': '12', 'year': '2024'});

      if (response.statusCode == 200) {
        final responseData = CalendarModelResponse.fromJson(response.data);

        if (responseData.table.isEmpty) {
          getCalendarResponseList = responseData.table;
          debugPrint('$response');
        } else {
          debugPrint('getCalendarResponseList is empty');
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
