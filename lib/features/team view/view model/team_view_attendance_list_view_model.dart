import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/team_view_attendance_list_model.dart';

class TeamViewAttendanceListViewModel {
  final Dio _dio = Dio();
  List<TeamViewAttendanceListModel>? attendanceList;
  SessionManager sessionManager = SessionManager();

  Future<void> fetchAttendanceList(String token) async {
    const url = '${AppConstants.baseUrl}/API/Duty/TeamViewDashBoardAttendacnceDeetailsCount';
    try {
      final userDetails = await sessionManager.getUserDetails();
      final reportingUserId = userDetails.userId;

      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'reportingUserId': reportingUserId},
      );

      if (response.statusCode == 200) {
        final responseData = AttendanceListResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          attendanceList = responseData.table;
          debugPrint('$response');
          debugPrint('Attendance data fetched successfully');
        } else {
          debugPrint('Table data is empty');
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
