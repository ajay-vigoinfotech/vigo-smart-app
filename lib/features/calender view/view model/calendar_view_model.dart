import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/constants.dart';
import '../../auth/session_manager/session_manager.dart';
import '../model/calendar_model.dart';
import '../model/calendar_request_model.dart';

class CalendarViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<CalendarModel>? getCalendarResponseList;

  Future<void> fetchCalendarResponseList(
      String token, CalendarRequestModel calendarRequestModel) async {
    const url =
        "${AppConstants.baseUrl}/API/Duty/GetDateRangeWiseAbsentPresentChartKotlin";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: calendarRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        final responseData = CalendarModelResponse.fromJson(response.data);
        getCalendarResponseList = responseData.table;
        // debugPrint('$response');
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
