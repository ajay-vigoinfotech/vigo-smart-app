import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/leave_history_model.dart';

class LeaveHistoryViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<LeaveHistoryModel>? leaveHistoryList;

  Future<void> fetchLeaveHistory(String token) async {
    const url = "${AppConstants.baseUrl}/API/PayRoll/GetEmployeeLeaveApp";

    try {
      final response = await _dio.post(
        url,
        options: Options(
            headers: {'Authorization': 'Bearer $token'},
            contentType: Headers.formUrlEncodedContentType),
        data: {'action':'7'},
      );

      if (response.statusCode == 200) {
        final responseData = LeaveHistoryResponse.fromJson(response.data);

        if (responseData.table.isNotEmpty) {
          leaveHistoryList = responseData.table;
          debugPrint('$response');
        } else {
          debugPrint('GetScheduleSiteListResponse is empty');
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
