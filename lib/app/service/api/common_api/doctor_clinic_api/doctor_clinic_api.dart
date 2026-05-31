import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'dart:convert';

class DoctorClinicApi {
  final ApiClient _apiClient = ApiClient();

  // GET - clinic profile
  Future<ApiResponse> getClinicProfile() async {
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getClinicProfile,
      authenticated: true,
    );
  }

  // POST - update clinic profile
  Future<ApiResponse> updateClinicProfile({
    required String clinicName,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String clinicFee,
    required String videoFee,
    List<String>? clinicPhotos,
  }) async {
    return await _apiClient.post(
      ApiConstants.commonApiConstants.updateClinicProfile,
      authenticated: true,
      data: {
        'clinic_name': clinicName,
        'physical_address': jsonEncode({
          // ✅ string
          'address_line1': addressLine1,
          'address_line2': addressLine2,
          'city': city,
        }),
        'clinic_visit_fee': clinicFee,
        'video_consult_fee': videoFee,
        if (clinicPhotos != null) 'clinic_photos': clinicPhotos, // ✅ list as-is
      },
    );
  }
}
