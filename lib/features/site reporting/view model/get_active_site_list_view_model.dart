import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/get_active_site_list_model.dart';

class GetActiveSiteListViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<GetActiveSiteListModel>? getActiveSiteList;

  Future<void> fetchGetActiveSiteList(String token, String searchText) async {
    const url = "${AppConstants.baseUrl}/API/Duty/GetActiveSiteList";
    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'SearchText': searchText},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Parse response data
        final List<dynamic> jsonList = response.data;
        getActiveSiteList = GetActiveSiteListModel.fromJsonList(jsonList);
      } else {
        throw Exception(
            'Failed to load active site list: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching active site list: $error');
      rethrow;
    }
  }
}
