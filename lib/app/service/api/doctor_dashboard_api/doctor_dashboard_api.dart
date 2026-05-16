import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorDashboardApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> getDoctorDashboard() async {
    return await _client.get(
      ApiConstants.commonApiConstants.getDoctorDashboard,
      authenticated: true,
    );
  }

  Future<ApiResponse> getAllBookings() async {
    return await _client.get(
      ApiConstants.commonApiConstants.getAllBookings,
      authenticated: true,
    );
  }
}
