import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class AiNutritionApi {
  final ApiClient _apiClient = ApiClient();

  // GET - saved nutrition plan
  Future<ApiResponse> getNutritionPlan() async {
    return await _apiClient.get(
      ApiConstants.commonApiConstants.getNutritionPlan,
      authenticated: true,
    );
  }

  // POST - save nutrition plan
  Future<ApiResponse> saveNutritionPlan({
    required String goal,
    required String activityLevel,
    required int dailyCalories,
    required List<Map<String, dynamic>> meals,
    required List<String> tags,
  }) async {
    return await _apiClient.post(
      ApiConstants.commonApiConstants.saveNutritionPlan,
      authenticated: true,
      options: Options(
        contentType: 'application/x-www-form-urlencoded', // ✅ Frappe format
      ),
      data: {
        'goal': goal,
        'activity_level': activityLevel,
        'daily_calories': dailyCalories,
        'meals': jsonEncode(meals), // ✅ List ko string mein convert karo
        'tags': jsonEncode(tags), // ✅ yeh bhi
      },
    );
  }
}
