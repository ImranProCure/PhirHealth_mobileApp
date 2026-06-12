import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class GoogleCalendarApi {
  final ApiClient _client = ApiClient();

  Future<ApiResponse> connectGoogleCalendar() async {
    return await _client.post(
      ApiConstants.commonApiConstants.connectGoogleCalendar,
      authenticated: true,
    );
  }
}
