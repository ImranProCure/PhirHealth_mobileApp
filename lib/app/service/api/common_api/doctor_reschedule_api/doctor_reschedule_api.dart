import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorRescheduleApi {
  final ApiClient _apiClient = ApiClient();

  // GET - current session details
  Future<ApiResponse> getCurrentSessionDetails({
    required String appointmentId,
  }) async {
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getCurrentSessionDetails,
      queryParameters: {'appointment_id': appointmentId},
      authenticated: true, // ✅ yeh add karo
    );
  }

  // GET - available slots
  Future<ApiResponse> getAvailableSlots({
    required String date,
  }) async {
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getAvailableSlots,
      queryParameters: {'date': date},
      authenticated: true, // ✅ yeh add karo
    );
  }

  // POST - reschedule appointment
  Future<ApiResponse> rescheduleAppointment({
    required String appointmentId,
    required String newDate,
    required String newTime,
    required String reason,
  }) async {
    return await _apiClient.post(
      ApiConstants.commonApiConstants.rescheduleAppointment,
      data: {
        'appointment_id': appointmentId,
        'new_date': newDate,
        'new_time': newTime,
        'reason': reason,
      },
      authenticated: true, // ✅ POST ke liye bhi add karo agar required ho
    );
  }
}
