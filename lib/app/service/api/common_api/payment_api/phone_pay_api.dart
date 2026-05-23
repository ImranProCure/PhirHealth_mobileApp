import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class PhonePayApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> getAppointments() async {
    return await _client.get(
      ApiConstants.commonApiConstants.doctorVisitApi,
      authenticated: true,
    );
  }

  // 1. Create payment link
  Future<ApiResponse> createPaymentLink({
    required String merchantReferenceId,
    required String customerName,
    required double amount,
    required String phoneNo,
    required String email,
  }) async {
    final formData = FormData.fromMap({
      'merchant_reference_id': merchantReferenceId,
      'customer_name': customerName,
      'amount': amount,
      'phone_no': phoneNo,
      'email': email,
    });

    // final formData = FormData.fromMap({
    //   'merchant_reference_id': "HLC-APP-2026-00094",
    //   'customer_name': "HLC-PAT-2026-00011",
    //   'amount': amount,
    //   'phone_no': phoneNo,
    //   'email': email,
    // });

    return await _client.post(
        ApiConstants
            .commonApiConstants.createPaymentlinkAPI, // your endpoint constant
        data: formData,
        authenticated: true);
  }

  Future<ApiResponse> createPaymentTransaction({
    required String transactionDate,
    required String transactionId,
    required String merchantReferenceId,
    required String customer,
    required String phonePeTransactionId,
    required String mandateType,
    required Map<String, dynamic> instrumentBreakdown,
    required String transactionNote,
    required double amount,
    required String status,
  }) async {
    final body = {
      'transaction_date': transactionDate,
      'transaction_id': transactionId,
      'merchant_reference_id': merchantReferenceId,
      'customer': customer,
      'phonepe_transaction_id': phonePeTransactionId,
      'mandate_type': mandateType,
      'instrument_breakdown': instrumentBreakdown,
      'transaction_note': transactionNote,
      'amount': amount,
      'status': status,
    };

    return await _client.post(
      ApiConstants.commonApiConstants.createTransactionPaymentAPI,
      data: body, // ← plain Map, NOT FormData
      options: Options(
        contentType: 'application/json', // ← force JSON content-type
      ),
      authenticated: true,
    );
  }
}
