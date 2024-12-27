import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/duplicate_aadhaar_model.dart';

class DuplicateAadhaarViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<DuplicateAadhaarModel>? duplicateAadhaarList;

  Future<bool> fetchDuplicateAadhaarList(String token, String aadhaarNo) async {
    const url = "${AppConstants.baseUrl}/API/ManageUser/CheckDuplicateAadhaar";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {'aadhaarNo': aadhaarNo},
      );
      if (response.statusCode == 200) {
        final responseData = DuplicateAadhaarResponse.fromJson(response.data);
        duplicateAadhaarList = responseData.table;

        // Return true if duplicate Aadhaar exists
        return duplicateAadhaarList != null && duplicateAadhaarList!.isNotEmpty;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return false; // Default return false if an error occurs
  }

}
