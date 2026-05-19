import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorPendingRequestApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> getPendingRequests() async {
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return await _client.get(
      ApiConstants.commonApiConstants.getPendingRequests,
      queryParameters: {'date': date},
      authenticated: true,
    );
  }

  Future<ApiResponse> acceptAppointment(String appointmentId) async {
    return await _client.post(
      ApiConstants.commonApiConstants.acceptAppointment,
      data: {'appointment_id': appointmentId},
      authenticated: true,
    );
  }

  Future<ApiResponse> cancelAppointment(String appointmentId) async {
    return await _client.post(
      ApiConstants.commonApiConstants.cancelAppointment,
      data: {'appointment_id': appointmentId},
      authenticated: true,
    );
  }

  Future<ApiResponse> getAppointmentDetails(String appointmentId) async {
    return await _client.get(
      ApiConstants.commonApiConstants.getAppointmentDetails,
      queryParameters: {'appointment_id': appointmentId},
      authenticated: true,
    );
  }

  Future<ApiResponse> getConfirmedAppointmentDetails(
      String appointmentId) async {
    return await _client.get(
      ApiConstants.commonApiConstants.getConfirmedAppointmentDetails,
      queryParameters: {'appointment_id': appointmentId},
      authenticated: true,
    );
  }
}
