import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/team_view_activity_attendance_list_model.dart';

class TeamViewActivityAttendanceListViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<TeamViewActivityAttendanceListModel>? teamActivityAttendanceList;

  Future<void> fetchTeamViewActivityAttendanceList(String token, String userId) async {
    const url = '${AppConstants.baseUrl}/API/Duty/GetSelfieAttendanceMgr';
    try {


      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'reportingUserId': userId },
      );

      if (response.statusCode == 200) {
        final responseData = TeamViewActivityAttendanceListResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          teamActivityAttendanceList = responseData.table;
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
