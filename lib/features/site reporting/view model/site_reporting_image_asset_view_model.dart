import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/site%20reporting/model/site_reporting_image_asset_model.dart';

class SiteReportingImageAssetViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<SiteReportingImageAssetModel>? siteReportingImageAssetList;

  Future<void> fetchSiteReportingImageAssetData(
      String token, String checkinId) async {
    const url =
        "${AppConstants.baseUrl}/API/SiteVisit/Question_Report_Site_AsstAndUserImageWeb";

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
        final responseData = SiteReportingImageAssetResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          siteReportingImageAssetList = responseData.table;
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