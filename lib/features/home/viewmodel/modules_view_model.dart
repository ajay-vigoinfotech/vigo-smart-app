    import 'package:dio/dio.dart';
    import 'package:vigo_smart_app/core/constants/constants.dart';

    class ModulesViewModel {
      final Dio _dio = Dio();

      Future<List<String>> getModules(String token) async {
        const url ='${AppConstants.baseUrl}/API/ManageUser/GetCompanyAssignModulle';
        try {
          final response = await _dio.post(
            url,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/x-www-form-urlencoded',
              },
            ),
            data: {'Action': '1'},
          );

          if (response.statusCode == 200) {
            final Set<String> seen = {};
            final List<String> moduleCodes = (response.data['table1'] as List)
                .map((item) => (item['moduleCode'] as String).substring(3))
                .where((moduleCode) => seen.add(moduleCode))
                .toList();

            return moduleCodes;
          } else {
            throw Exception('Failed to load module codes');
          }
        } catch (e) {
          print(e);
          return [];
        }
      }
    }
