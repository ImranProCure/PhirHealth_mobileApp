import 'package:dio/dio.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class AuthenticationApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> login({
    required String flag,
    required String country_code,
    required String mobile,
    required String role,
  }) async {
    final data = {
      'flag': flag,
      'country_code': country_code,
      "mobile": mobile,
      'role': role,
    };
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.login,
      data: data,
    );
    return response;
  }

  Future<ApiResponse> resendOtp({
    required String country_code,
    required String mobile,
    required String flag,
    required String role,
  }) async {
    final data = {
      'flag': flag,
      'country_code': country_code,
      "mobile": mobile,
      'role': role,
    };
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.resendOtp,
      data: data,
    );
    return response;
  }

  Future<ApiResponse> getMedicalSymptoms() async {
    // final queryParameters = {'batch_id': batchId};

    return await _client.get(
      ApiConstants.commonApiConstants.getSymstom,
      // queryParameters: queryParameters,
      authenticated: true,
    );
  }

  Future<ApiResponse> getAllergies() async {
    // final queryParameters = {'batch_id': batchId};

    return await _client.get(
      ApiConstants.commonApiConstants.getAllergy,
      // queryParameters: queryParameters,
      authenticated: true,
    );
  }

  Future<ApiResponse> getMedicalConditions() async {
    // final queryParameters = {'batch_id': batchId};

    return await _client.get(
      ApiConstants.commonApiConstants.getexistingConditions,
      // queryParameters: queryParameters,
      authenticated: true,
    );
  }

  Future<ApiResponse> getProfileDetail() async {
    // final queryParameters = {'batch_id': batchId};

    return await _client.get(
      ApiConstants.commonApiConstants.patientProfileView,
      // queryParameters: queryParameters,
      authenticated: true,
    );
  }

  Future<ApiResponse> patientSignup({
    Map<String, dynamic>? fields,
    required String filePath,
  }) async {
    fields!['photo'] = await MultipartFile.fromFile(filePath);

    final formData = FormData.fromMap(fields); // ← This was missing

    return await _client.postMultipart(
      ApiConstants.commonApiConstants.patientSignup,
      formData: formData,
      authenticated: false,
    );
  }

  Future<ApiResponse> patientEditProfile({
    Map<String, dynamic>? fields,
    String? filePath, // 👈 make optional
  }) async {
    fields ??= {};

    // 👇 Only add photo if filePath is provided
    if (filePath != null && filePath.isNotEmpty) {
      fields['photo'] = await MultipartFile.fromFile(filePath);
    }

    final formData = FormData.fromMap(fields);

    return await _client.postMultipart(
      ApiConstants.commonApiConstants.patientProfileEdit,
      formData: formData,
      authenticated: false,
    );
  }

  Future<ApiResponse> createMedicalCondition({
    required String name,
  }) async {
    final data = {"condition": name};
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.createConditions,
      data: data,
    );
    return response;
  }

  Future<ApiResponse> createAllergy({
    required String name,
  }) async {
    final data = {"allergy": name};
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.createAllergy,
      data: data,
    );
    return response;
  }

  Future<ApiResponse> createMedicalSymptom({
    required String name,
  }) async {
    final data = {"symptom": name};
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.createSymton,
      data: data,
    );
    return response;
  }

  Future<ApiResponse> verifyOtp({
    required String otp,
    required String country_code,
    required String mobile,
    required String role,
  }) async {
    final data = {
      'otp': otp,
      'country_code': country_code,
      "mobile": mobile,
      'role': role,
    };
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.otpVerify,
      data: data,
    );
    return response;
  }

  Future<ApiResponse> verifyDoctorOtp({
    required String otp,
    required String country_code,
    required String mobile,
    required String role,
  }) async {
    final data = {
      'otp': otp,
      'country_code': country_code,
      "mobile": mobile,
      'role': role,
    };

    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.doctorOtpVerify,
      data: data,
    );

    return response;
  }

//   Future<ApiResponse> signup({
//     required String email,
//     required String fullName,
//     required String password,
//     required String mobileNo,
//     required String roles,
//   }) async {
//     final data = {
//       'email': email,
//       'full_name': fullName,
//       'password': password,
//       'mobile_no': mobileNo,
//       'roles': roles,
//     };
//     final ApiResponse response = await _client.post(
//       ApiConstants.commonApiConstants.signup,
//       data: data,
//     );
//     return response;
//   }

//   Future<ApiResponse> logout() async {
//     final ApiResponse response = await _client.post(
//       ApiConstants.commonApiConstants.logout,
//       authenticated: true,
//     );
//     return response;
//   }
// }
}
