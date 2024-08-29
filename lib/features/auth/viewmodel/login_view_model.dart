import 'package:http/http.dart' as http;
import '../../../core/constants/constants.dart';
import '../model/login_model.dart';

class LoginViewModel {
  Future<bool> makeRequest(LoginRequest request) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/token');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: request.toMap(),
      );

      if (response.statusCode == 200) {
        // Handle success scenario
        //print('Response: ${response.body}');
        return true;
      } else {
        // Handle unsuccessful response
        //print('Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      //print('Exception: $e');
      return false;
    }
  }
}
