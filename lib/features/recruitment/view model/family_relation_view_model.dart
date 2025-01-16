import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/family_relation_model.dart';

class FamilyRelationViewModel {
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<FamilyRelationModel>? familyRelationList;

  Future<void> fetchFamilyRelationList(String token) async {
    const url = "${AppConstants.baseUrl}/API/ManageUser/SelectFamilyRelation";

    try {
      final response = await _dio.post(url,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            contentType: Headers.formUrlEncodedContentType,
          ));

      if (response.statusCode == 200) {
        final responseData = FamilyRelationResponse.fromJson(response.data);
        familyRelationList = responseData.table;
        // debugPrint('$response');
      } else {
        debugPrint(
            'Error :: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio Error ${e.message}');
    } catch (e) {
      debugPrint('$e');
    }
  }
}
