import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import '../model/leave_balance_model.dart';

class LeaveBalanceViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();

  List<LeaveBalanceModel>? leavesBalanceList;
  List<LeaveNameModel>? leaveNameList;

  Future<void> fetchEmployeeLeaves(String token) async {
    const url = "${AppConstants.baseUrl}/API/ManageUser/GetEmployeeLeaves";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = LeaveBalanceResponse.fromJson(response.data);
        leavesBalanceList = responseData.table;
        leaveNameList = responseData.table1;
        // debugPrint('$response');
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
