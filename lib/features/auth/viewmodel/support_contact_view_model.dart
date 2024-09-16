import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';

class SupportContactViewModel {
  final Dio _dio = Dio();

  // Fetch SupportContact from API
  Future<String> getSupportContact() async {
    try {
      const url = '${AppConstants
          .baseUrl}/API/SystemMasters/GetSupportContacts';

      final headers = {
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'User-Agent': 'okhttp/4.9.1',
      };

      Response response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final supportContact = response.data.toString();
        print('Fetched support contact: $supportContact');

        return supportContact;
      } else {
        print('Error: ${response.statusCode}');
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception: $e');
      return 'Exception: $e';
    }
  }
}