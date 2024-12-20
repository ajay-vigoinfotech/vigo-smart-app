import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/team_dashboard_count_model.dart';

class TeamDashboardCountViewModel {
  final Dio _dio = Dio();
  TeamDashboardCountModel? teamDashboardCount;
  SessionManager sessionManager = SessionManager();

  Future<void> fetchTeamDashboardCount(String token) async {
    const url = '${AppConstants.baseUrl}/API/Duty/TeamViewDashBoardCount';
    try {
      final userDetails = await sessionManager.getUserDetails();
      final reportingUserId = userDetails.userId;
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'ReportingUserId': reportingUserId},
      );

      if (response.statusCode == 200) {
        final responseData = TeamDashboardResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          teamDashboardCount = responseData.table[0];
        } else {
          debugPrint('Table data is empty');
        }
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}