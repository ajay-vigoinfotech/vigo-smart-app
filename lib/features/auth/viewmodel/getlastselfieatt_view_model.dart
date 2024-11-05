import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import '../model/getlastselfieattendancemodel.dart';
import '../session_manager/session_manager.dart';

class GetLastSelfieAttViewModel {
  final Dio _dio = Dio();
  SelfieAttendanceModel? selfieAttendance;

  Future<bool> getLastSelfieAttendance(String token) async {
    const url = '${AppConstants.baseUrl}/API/Kotlin/GetLastSelfieAttendance';

    try {
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final SessionManager sessionManager = SessionManager();
        debugPrint('Response data: ${response.data}');

        selfieAttendance = SelfieAttendanceModel.fromJson(response.data);
        await sessionManager.saveSelfieAttendance(selfieAttendance!);
        return true;
      } else {
        debugPrint("Error: Status code ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      return false;
    }
  }
}
