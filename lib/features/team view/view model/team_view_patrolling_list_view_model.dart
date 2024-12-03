import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/team%20view/model/team_view_patrolling_list_model.dart';

class TeamViewPatrollingListViewModel {
  final Dio _dio = Dio();
  List<TeamViewPatrollingListModel>? patrollingList;
  SessionManager sessionManager = SessionManager();

  Future<void> fetchPatrollingList(String token) async {
    const url = "${AppConstants.baseUrl}/API/Duty/TeamViewDashBoardFieldDeetailsCount";
    try {
      final userDetails = await sessionManager.getUserDetails();
      final reportingUserId = userDetails.userId;

      final response = await _dio.post(
       url,
       options: Options(
         headers: {'Authorization' : 'Bearer $token'},
         contentType: Headers.formUrlEncodedContentType,
       ),
         data: {'reportingUserId' : reportingUserId}
      );

      if(response.statusCode == 200) {
        final responseData = PatrollingListResponse.fromJson(response.data);
        if(responseData.table.isNotEmpty) {
          //debugPrint('$response');
          patrollingList = responseData.table;
        } else {
          debugPrint('Table Data is Empty');
        }
      } else {
        debugPrint('${response.statusMessage} - ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error : $e');
    } catch (e) {
      debugPrint('$e');
    }
  }
}