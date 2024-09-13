import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';

class GetCurrentDateViewModel {
  final Dio _dio = Dio();

  Future<String?> getTimeDate() async {
    const url = '${AppConstants.baseUrl}/API/ManageUser/GetCurrentDate';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'okhttp/4.9.1',
            'Content-Length': '0',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return response.data.toString();
      } else {
        print('Error: ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');

      return null;
    }
  }
}
