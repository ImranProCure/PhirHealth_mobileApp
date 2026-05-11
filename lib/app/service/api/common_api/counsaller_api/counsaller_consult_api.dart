import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class CounsallerConsultApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> getCounsaller({Map<String, String>? queryParams}) async {
    return await _client.get(
      ApiConstants.commonApiConstants.counsallerList,
      queryParameters: queryParams,
      authenticated: true,
    );
  }

  Future<ApiResponse> getDoctorProfile(
      {Map<String, String>? queryParams}) async {
    return await _client.get(
      ApiConstants.commonApiConstants.profileCounsallerDetails,
      queryParameters: queryParams,
      authenticated: true,
    );
  }

  Future<ApiResponse> getWalletBalance() async {
    return await _client.get(
      ApiConstants.commonApiConstants.walletBalance,
      authenticated: true,
    );
  }

  Future<ApiResponse> bookAppointment({
    required String practitioner,
    required String appointmentDate,
    required String startTime,
    required String endTime,
    required String appointmentType,
    required int fees,
    required String modeOfPayment,
    required String patientId,
    required List<File> reports,
    required List<Map<String, String>> reportData,
  }) async {
    final formData = FormData.fromMap({
      'practitioner': practitioner,
      'appointment_date': appointmentDate,
      'start_time': startTime,
      'end_time': endTime,
      'appointment_type': appointmentType,
      'fees': fees.toString(),
      'mode_of_payment': modeOfPayment,
      'patient_id ': patientId,

      // reports[] — each file as multipart
      'reports': [
        for (final file in reports)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      ],

      // report_data[] — JSON-encoded per item so index matches reports[]
      'report_data': reportData.map((e) => jsonEncode(e)).toList(),
    });

    return await _client.post(
        ApiConstants
            .commonApiConstants.bookAppointment, // your endpoint constant
        data: formData,
        authenticated: true);
  }

  Future<ApiResponse> getPatientRelations() async {
    return await _client.get(
      ApiConstants.commonApiConstants.relationListApi,
      authenticated: true,
    );
  }

  Future<ApiResponse> getCounsallerSpecialities() async {
    return await _client.get(
      ApiConstants.commonApiConstants.specialistCousallerList,
      authenticated: true,
    );
  }

  Future<ApiResponse> getAllReviews({Map<String, dynamic>? queryParams}) async {
    return await _client.get(
      ApiConstants.commonApiConstants.reviewListCounsallerApi,
      queryParameters: queryParams,
      authenticated: true,
    );
  }

  Future<ApiResponse> addPatientRelation(data) async {
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.relationAddApi,
      data: data,
      authenticated: true,
    );
    return response;
  }

  Future<ApiResponse> submitReview(data) async {
    final ApiResponse response = await _client.post(
      ApiConstants.commonApiConstants.submitCounsallerReview,
      data: data,
      authenticated: true,
    );
    return response;
  }
}
