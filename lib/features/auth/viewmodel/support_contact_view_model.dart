import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import '../model/support_contact_model.dart';

class SupportContactViewModel {
  final Dio _dio = Dio();

  // Fetch SupportContact from API
  Future<SupportContact?> getSupportContact() async {
    const url = '${AppConstants.baseUrl}/API/SystemMasters/GetSupportContacts';
    try {
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
        // Directly access the response data as a map
        final data = response.data;

        // Access the first item in the 'table' list if it exists
        if (data['table'] != null && data['table'] is List && data['table'].isNotEmpty) {
          final contactData = data['table'][0];
          final supportContact = SupportContact.fromJson(contactData);

          print('Fetched support contact - IVR: ${supportContact.ivr}, WhatsApp: ${supportContact.whatsapp}');
          return supportContact;
        } else {
          print('Error: "table" list is empty or not found in response');
          return null;
        }
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}