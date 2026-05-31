import 'package:dio/dio.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'dart:convert';

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
    return await _client.post(ApiConstants.commonApiConstants.login,
        data: data);
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
    return await _client.post(ApiConstants.commonApiConstants.resendOtp,
        data: data);
  }

  Future<ApiResponse> getMedicalSymptoms() async {
    return await _client.get(ApiConstants.commonApiConstants.getSymstom,
        authenticated: true);
  }

  Future<ApiResponse> getAllergies() async {
    return await _client.get(ApiConstants.commonApiConstants.getAllergy,
        authenticated: true);
  }

  Future<ApiResponse> getMedicalConditions() async {
    return await _client.get(
        ApiConstants.commonApiConstants.getexistingConditions,
        authenticated: true);
  }

  Future<ApiResponse> getProfileDetail() async {
    return await _client.get(ApiConstants.commonApiConstants.patientProfileView,
        authenticated: true);
  }

  Future<ApiResponse> patientSignup({
    Map<String, dynamic>? fields,
    required String filePath,
  }) async {
    fields!['photo'] = await MultipartFile.fromFile(filePath);
    final formData = FormData.fromMap(fields);
    return await _client.postMultipart(
      ApiConstants.commonApiConstants.patientSignup,
      formData: formData,
      authenticated: false,
    );
  }

  Future<ApiResponse> patientEditProfile({
    Map<String, dynamic>? fields,
    String? filePath,
  }) async {
    fields ??= {};
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

  Future<ApiResponse> createMedicalCondition({required String name}) async {
    return await _client.post(ApiConstants.commonApiConstants.createConditions,
        data: {"condition": name});
  }

  Future<ApiResponse> createAllergy({required String name}) async {
    return await _client.post(ApiConstants.commonApiConstants.createAllergy,
        data: {"allergy": name});
  }

  Future<ApiResponse> createMedicalSymptom({required String name}) async {
    return await _client.post(ApiConstants.commonApiConstants.createSymton,
        data: {"symptom": name});
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
      'role': role
    };
    return await _client.post(ApiConstants.commonApiConstants.otpVerify,
        data: data);
  }

  Future<ApiResponse> verifyDoctorOtp({
    required String otp,
    required String country_code,
    required String mobile,
    required String role,
    required String flag, // ✅ Yeh add karo
  }) async {
    final data = {
      'otp': otp,
      'country_code': country_code,
      'mobile': mobile,
      'role': role,
      'flag': flag, // ✅ Yeh add karo
    };
    return await _client.post(ApiConstants.commonApiConstants.doctorOtpVerify,
        data: data);
  }

  // ADDED: Doctor signup — multipart (profile photo + clinic photos)
  Future<ApiResponse> doctorSignup({
    required Map<String, dynamic> fields,
    String? profileImagePath,
    List<String> clinicPhotoPaths = const [],
  }) async {
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      fields['profile_image'] = await MultipartFile.fromFile(profileImagePath);
    }

    if (clinicPhotoPaths.isNotEmpty) {
      fields['clinic_photos'] = await Future.wait(
        clinicPhotoPaths.map((p) => MultipartFile.fromFile(p)),
      );
    }

    final formData = FormData.fromMap(fields);
    return await _client.postMultipart(
      ApiConstants.commonApiConstants.doctorSignup,
      formData: formData,
      authenticated: false,
    );
  }

  // Future<ApiResponse> getDoctorExperience() async {
  //   return await _client.get(
  //     ApiConstants.commonApiConstants.getDoctorExperience,
  //     authenticated: true,
  //   );
  // }

  // Future<ApiResponse> saveDoctorExperience({
  //   required Map<String, dynamic> data,
  // }) async {
  //   return await _client.post(
  //     ApiConstants.commonApiConstants.saveDoctorExperience,
  //     data: data,
  //     authenticated: true,
  //   );
  // }

  Future<ApiResponse> getCareExperience() async {
    return await _client.get(
      '/api/method/vhealthcare.api.doctor.dr_registration.care_experience.get_care_experience',
      authenticated: false,
    );
  }

  Future<ApiResponse> createCareExperience({
    required String name,
  }) async {
    return await _client.post(
      '/api/method/vhealthcare.api.doctor.dr_registration.care_experience.add_care_experience',
      data: {
        'care_experience': name,
      },
      authenticated: false,
    );
  }

  Future<ApiResponse> getDoctorProfile() async {
    return await _client.get(
      '/api/method/vhealthcare.api.doctor.my_profile.dr_profile.get_doctor_profile',
      authenticated: true,
    );
  }

  Future<ApiResponse> updateDoctorProfile({
    required Map<String, dynamic> fields,
    String? profileImagePath,
    List<String> clinicPhotoPaths = const [],
  }) async {
    final FormData formData = FormData();

    /// ===== NORMAL FIELDS =====
    fields.forEach((key, value) {
      if (key != 'custom_current_practice_place' &&
          key != 'custom_care_experience' &&
          key != 'existing_clinic_photos') {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    final List<String> practicePlaces = List<String>.from(
      fields['custom_current_practice_place'] ?? [],
    );

    formData.fields.add(
      MapEntry(
        'custom_current_practice_place',
        jsonEncode(practicePlaces),
      ),
    );

    /// ===== CARE EXPERIENCE — send as single string list =====
    final List<String> careExperiences = List<String>.from(
      fields['custom_care_experience'] ?? [],
    );

    formData.fields.add(
      MapEntry(
        'custom_care_experience',
        jsonEncode(careExperiences),
      ),
    );

    /// ===== EXISTING CLINIC PHOTOS =====
    final List<String> existingPhotos = List<String>.from(
      fields['existing_clinic_photos'] ?? [],
    );
    for (final photo in existingPhotos) {
      formData.fields.add(
        MapEntry('existing_clinic_photos', photo),
      );
    }

    /// ===== PROFILE IMAGE =====
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'profile_image',
          await MultipartFile.fromFile(profileImagePath),
        ),
      );
    }

    /// ===== CLINIC PHOTOS =====
    for (final path in clinicPhotoPaths) {
      formData.files.add(
        MapEntry(
          'clinic_photos',
          await MultipartFile.fromFile(path),
        ),
      );
    }

    print("FIELDS => ${formData.fields}");
    print("FILES  => ${formData.files}");

    return await _client.postMultipart(
      ApiConstants.commonApiConstants.updateDoctorProfile,
      formData: formData,
      authenticated: true,
    );
  }
}
