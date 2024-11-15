import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/model/getuserdetails.dart';
import '../session_manager/session_manager.dart';

class UserViewModel {
  final Dio _dio = Dio();
  GetUserDetails? user;

  Future<void> getUserDetails(String token) async {
    const url = '${AppConstants.baseUrl}/API/ManageUser/GetUserDetails';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'okhttp/4.9.1',
          },
        ),
      );

      if (response.statusCode == 200) {
        final SessionManager sessionManager = SessionManager();
        print(response.data);
        user = GetUserDetails.fromJson(response.data);
        await sessionManager.saveUserDetails(user!);
        // print('User details saved in session.');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
