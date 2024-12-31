  import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/team%20view/model/team_view_activity_attendance_model.dart';

class TeamViewActivityAttendanceViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<TeamViewActivityAttendanceModel>? teamActivityAttendanceCount;

  Future<void> fetchTeamActivityAttendanceCount(String token) async {
    const url = '${AppConstants.baseUrl}/API/ManageUser/GetReportingEmployees';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = TeamViewActivityAttendanceResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          teamActivityAttendanceCount = responseData.table;
          debugPrint('$response');
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
