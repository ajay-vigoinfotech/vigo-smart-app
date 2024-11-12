import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/team%20view/model/team_dashboard_site_count_model.dart';

class TeamViewDashBoardSiteCountViewModel {
  final Dio _dio = Dio();
  TeamDashboardSiteCountModel? siteDashBoardCount;
  SessionManager sessionManager = SessionManager();

  Future<void> fetchSiteDashboardCount(String token) async {
    const url = '${AppConstants.baseUrl}/API/Duty/TeamViewDashBoardSiteCount';
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
        final responseData = SiteDashboardResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          siteDashBoardCount = responseData.table[0];
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