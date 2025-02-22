import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/site%20reporting/model/previous_site_reporting_list_model.dart';

class PreviousSiteReportingListViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<PreviousSiteReportingListModel>? previousSiteReportingList;

  Future<void> fetchPreviousSiteReportingListData(
      String token, String checkinId) async {
    const url =
        "${AppConstants.baseUrl}/API/SiteVisit/GetSiteActivityDetailsWeb";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'checkinId': checkinId},
      );

      if (response.statusCode == 200) {
        final responseData = PreviousSiteReportingListResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          previousSiteReportingList = responseData.table;
          debugPrint('$response');
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
