import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/constants.dart';
import '../../auth/session_manager/session_manager.dart';
import '../model/team_view_activity_patrolling_list_model.dart';

class TeamViewActivityPatrollingListViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<TeamViewActivityPatrollingListModel>? teamActivityPatrollingList;

  Future<void> fetchTeamViewActivityPatrollingList(String token, String userId) async {
    const url = '${AppConstants.baseUrl}/API/CheckIns/GetCheckinListMgr';
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
        final responseData = TeamViewActivityPatrollingListResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          teamActivityPatrollingList = responseData.table;
          //debugPrint('$response');
        } else {
          debugPrint('teamActivityPatrollingList is empty');
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


