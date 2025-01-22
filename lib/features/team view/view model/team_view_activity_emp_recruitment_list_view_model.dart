import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/constants.dart';
import '../../auth/session_manager/session_manager.dart';
import '../model/team_view_activity_emp_recruitment_list_model.dart';

class TeamViewActivityEmpRecruitmentListViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<TeamViewActivityEmpRecruitmentListModel>? teamActivityEmpRecruitmentList;

  Future<void> fetchTeamViewActivityEmpRecruitmentList(String token, String userId) async {
    const url = '${AppConstants.baseUrl}/API/ManageUser/GetReportingEmpRecruitmentApp';
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
        final responseData = TeamViewActivityEmpRecruitmentListResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          teamActivityEmpRecruitmentList = responseData.table;
          //debugPrint('$response');
        } else {
          debugPrint('teamActivityEmpRecruitmentList is empty');
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


