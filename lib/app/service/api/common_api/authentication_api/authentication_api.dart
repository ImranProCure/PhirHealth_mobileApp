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
  }) async {
    final data = {'flag': flag, 'country_code': country_code, "mobile": mobile};
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
  }) async {
    final data = {'flag': flag, 'country_code': country_code, "mobile": mobile};
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.resendOtp,
      data: data,
    );
    return response;
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

  Future<ApiResponse> verifyOtp({
    required String otp,
    required String country_code,
    required String mobile,
  }) async {
    final data = {'otp': otp, 'country_code': country_code, "mobile": mobile};
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.otpVerify,
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
