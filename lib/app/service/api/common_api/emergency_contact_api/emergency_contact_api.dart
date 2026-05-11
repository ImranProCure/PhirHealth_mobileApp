import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class EmergencyContactApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> getEmergencyContacts() async {
    return await _client.get(
      ApiConstants.commonApiConstants.getEmergencyContacts,
      authenticated: true,
    );
  }

  Future<ApiResponse> addEmergencyContact({
    required String contactName,
    required String relation,
    required String phoneNumber,
  }) async {
    return await _client.post(
      ApiConstants.commonApiConstants.addEmergencyContact,
      data: {
        'contact_name': contactName,
        'relation': relation,
        'phone_number': phoneNumber,
      },
      authenticated: true,
    );
  }
}
