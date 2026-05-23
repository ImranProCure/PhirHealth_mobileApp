import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class DoctorReviewsApi {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getDoctorReviews({String? filter}) async {
    // 'All' → 'all', '5 Stars' → '5', '4 Stars' → '4', etc.
    String rating = 'all';
    if (filter != null && filter != 'All') {
      rating = filter.replaceAll(' Stars', '').replaceAll(' Star', '').trim();
    }
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getDoctorReviews,
      queryParameters: {'rating': rating},
      authenticated: true,
    );
  }
}
