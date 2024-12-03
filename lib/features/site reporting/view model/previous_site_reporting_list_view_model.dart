import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';

class PreviousSiteReportingListViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();

  Future<void> fetchPreviousSiteReportingListData(String token) async {
    const url = "${AppConstants.baseUrl}/API/SiteVisit/GetSiteActivityDetailsWeb";

  }
}