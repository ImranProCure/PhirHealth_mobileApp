import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorConsultApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> getDoctors({Map<String, String>? queryParams}) async {
    return await _client.get(
      ApiConstants.commonApiConstants.doctorList,
      queryParameters: queryParams,
      authenticated: true,
    );
  }

  Future<ApiResponse> getSpecialities() async {
    return await _client.get(
      ApiConstants.commonApiConstants.specialistList,
      authenticated: true,
    );
  }
  // Future<ApiResponse> createAllergy({
  //   required String name,
  // }) async {
  //   final data = {"allergy": name};
  //   final ApiResponse response = await _client.post(
  //     ApiConstants.commonApiConstants.createAllergy,
  //     data: data,
  //   );
  //   return response;
  // }
}
