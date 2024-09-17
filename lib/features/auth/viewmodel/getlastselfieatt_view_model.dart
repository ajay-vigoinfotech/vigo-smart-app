import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import '../model/getlastselfieattendancemodel.dart';
import '../session_manager/session_manager.dart';

class GetlastselfieattViewModel {
  final Dio _dio = Dio();
  SelfieAttendanceModel? selfieAttendance;

  Future<GetlastselfieattViewModel?> getLastSelfieAttendance(
      String token) async {
    try {
      const url = '${AppConstants.baseUrl}/API/Kotlin/GetLastSelfieAttendance';

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'User-Agent': 'okhttp/4.9.1',
      };

      Response response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final SessionManager sessionManager = SessionManager();
        print(response.data);
        print(response.data);

        selfieAttendance = SelfieAttendanceModel.fromJson(response.data);
        await sessionManager.saveSelfieAttendance(selfieAttendance!);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
    return null;
  }
}
