import 'package:dio/dio.dart';
import 'package:vigo_smart_app/core/constants/constants.dart';
import 'package:vigo_smart_app/features/auth/session_manager/session_manager.dart';
import 'package:vigo_smart_app/features/recruitment/model/document_type_model.dart';

class DocumentTypeViewModel{
  final Dio _dio = Dio();
  SessionManager sessionManager = SessionManager();
  List<DocumentTypeModel>? documentTypeList;

  Future<void> fetchDocumentType(String token) async {
    const url = "${AppConstants.baseUrl}/API/ManageUser/GetDocumentType";

    try {
      final response = await _dio.get(
          url,
          options: Options(
              headers: {'Authorization': 'Bearer $token'},
              contentType: Headers.formUrlEncodedContentType));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // final responseData = response.data;
        // documentTypeList = responseData;
        documentTypeList = data.map((e) => DocumentTypeModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch states: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching state list: $e');
    }
  }
}