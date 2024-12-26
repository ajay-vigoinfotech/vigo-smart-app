import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/branch_list_model.dart';

class BranchListViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<BranchListModel>? assignBranchList;

  Future<void> fetchAssignBranchList(String token) async {
    const url = "${AppConstants.baseUrl}/API/ManageUser/GetBranchListApp";

    try {
      final response = await _dio.post(url,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            contentType: Headers.formUrlEncodedContentType,
          ));

      if (response.statusCode == 200) {
        final responseData = BranchListResponse.fromJson(response.data);
        assignBranchList = responseData.table;
        debugPrint('$response');
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
