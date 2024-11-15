import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/team_view_site_list_model.dart';

class TeamViewSiteListViewModel {
  final Dio _dio = Dio();
  List<TeamViewSiteListModel>? siteList;
  SessionManager sessionManager = SessionManager();

  Future<void> fetchSitList(String token) async {
    const url = "${AppConstants.baseUrl}/API/Duty/TeamViewDashBoardSiteDeetailsCount";
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
        final responseData = SiteListResponse.fromJson(response.data);
        if(responseData.table.isNotEmpty) {
          debugPrint('$response');
          siteList = responseData.table;
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