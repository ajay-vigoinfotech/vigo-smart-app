import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/constants.dart';
import '../model/getselfieattendance_model.dart';

class GetSelfieAttendanceViewModel {
  final Dio _dio = Dio();
  GetSelfieAttendanceModel? getSelfieAttendanceModel;

  Future<GetSelfieAttendanceViewModel?> getSelfieAttendance(String token) async {
    try {
      const url = '${AppConstants.baseUrl}/API/Kotlin/GetSelfieAttendance';

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
        getSelfieAttendanceModel = GetSelfieAttendanceModel.fromJson(response.data);
        return this;
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      debugPrint('DioError: $e.message}');
      return null;
    } catch (e) {
      debugPrint('Error::: $e');
      return null;
    }
  }
}
