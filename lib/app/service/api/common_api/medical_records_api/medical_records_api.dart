import 'dart:io';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:dio/dio.dart';

class MedicalRecordsApi {
  final ApiClient _client = ApiClient();

  /// ===== GET MEDICAL RECORDS =====
  Future<ApiResponse> getMedicalRecords() async {
    return await _client.get(
      ApiConstants.commonApiConstants.getMedicalRecords,
      authenticated: true,
    );
  }

  /// ===== UPLOAD MEDICAL RECORD =====
  Future<ApiResponse> uploadMedicalRecord({
    required List<File> files,
    required String recordType,
  }) async {
    // CHANGE: FormData.fromMap async nahi handle karta
    // Pehle MultipartFile list banao, phir FormData mein do
    final List<MultipartFile> multipartFiles = [];
    for (final file in files) {
      multipartFiles.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    final formData = FormData.fromMap({
      'record_type': recordType,
      'reports': multipartFiles, // ← 'files' se 'reports' karo
    });

    return await _client.postMultipart(
      ApiConstants.commonApiConstants.uploadMedicalFile,
      formData: formData,
      authenticated: true,
    );
  }
}
