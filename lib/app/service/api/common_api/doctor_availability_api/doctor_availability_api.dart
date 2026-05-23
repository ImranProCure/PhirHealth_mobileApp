import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorAvailabilityApi {
  final ApiClient _apiClient = ApiClient();

  // GET - day slots
  Future<ApiResponse> getAvailabilitySlots() async {
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getAvailabilitySlots,
    );
  }

  // GET - edit day
  Future<ApiResponse> getDaySlots({
    required String schedule,
    required String day,
  }) async {
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getDayAvailabilitySlots,
      queryParameters: {
        'schedule': schedule,
        'day': day,
      },
    );
  }

  // POST - update slots
  Future<ApiResponse> updateDaySlots({
    required String schedule,
    required String day,
    required String action, // 'add' or 'delete'
    required String fromTime,
    required String toTime,
    required String slotDuration,
    required String session,
  }) async {
    return await _apiClient.post(
      ApiConstants.commonApiConstants.updateDayAvailabilitySlots,
      data: {
        'schedule': schedule,
        'day': day,
        'action': action,
        'from_time': fromTime,
        'to_time': toTime,
        'slot_duration': slotDuration,
        'session': session,
      },
    );
  }
}
