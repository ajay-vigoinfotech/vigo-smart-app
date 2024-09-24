// import 'package:dio/dio.dart';
// import 'package:vigo_smart_app/core/constants/constants.dart';
//
// class CheckSessionViewModel {
//   final Dio _dio = Dio();
//
//   Future<String> checkSession(String token) async {
//     const url = '${AppConstants.baseUrl}/API/Kotlin/CheckSession';
//
//     try {
//       final response = await _dio.post(
//         url,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         print('error ${response.statusCode}');
//         return response.data;
//       }
//     } catch (e) {
//       print('Exception : ${e}');
//     }
//   }
// }
