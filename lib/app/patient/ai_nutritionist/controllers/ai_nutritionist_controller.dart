import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/ai_nutrition_api/ai_nutrition_api.dart';
import '../../ai_nutritionist_result/controllers/ai_nutritionist_result_controller.dart';

class AiNutritionistController extends GetxController {
  final AiNutritionApi _api = AiNutritionApi();

  final RxString selectedGoal = 'Weight Loss'.obs;
  final RxString selectedFood = 'Vegetarian'.obs;
  final RxInt activityLevel = 3.obs;
  final RxList<String> selectedAllergies = <String>['Peanuts'].obs;
  final RxList<String> customAllergies = <String>[].obs;

  // Loading + error state
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSaved = false.obs;
  final RxString errorMessage = ''.obs;

  final List<Map<String, dynamic>> goals = [
    {
      'label': 'Weight Loss',
      'sub': 'Burn Fat',
      'imagePath': 'assets/icons/measuring-tape 1.png'
    },
    {
      'label': 'Muscle Gain',
      'sub': 'Build Strength',
      'imagePath': 'assets/icons/muscle 1.png'
    },
  ];

  final List<Map<String, dynamic>> foods = [
    {'label': 'Vegetarian', 'imagePath': 'assets/icons/broccoli 1.png'},
    {'label': 'Non-Veg', 'imagePath': 'assets/icons/chicken-leg 1.png'},
    {'label': 'Vegan', 'imagePath': 'assets/icons/salad (1) 1.png'},
    {'label': 'Eggitarian', 'imagePath': 'assets/icons/eggs 1.png'},
  ];

  final List<String> activityLabels = [
    'Sedentary',
    'Lightly',
    'Moderate',
    'Active',
    'Very Active'
  ];

  final List<String> allergies = ['Peanuts', 'Antibiotics', 'Dust'];

  void selectGoal(String g) => selectedGoal.value = g;
  void selectFood(String f) => selectedFood.value = f;
  void setActivity(int i) => activityLevel.value = i;

  void toggleAllergy(String a) {
    selectedAllergies.contains(a)
        ? selectedAllergies.remove(a)
        : selectedAllergies.add(a);
  }

  void addCustomAllergy(String a) => customAllergies.add(a);
  void removeCustomAllergy(String a) => customAllergies.remove(a);

  List<String> get allAllergies => [...selectedAllergies, ...customAllergies];
  String get activityLabel => activityLabels[activityLevel.value];

  // ===== GENERATE PLAN — GROQ =====
  Future<void> generatePlan() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final dio = Dio();
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

      final response = await dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          'temperature': 0.9,
          'response_format': {'type': 'json_object'},
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert Indian nutritionist. Always respond with valid JSON only. No markdown, no explanation, no extra text.',
            },
            {
              'role': 'user',
              'content': _buildPrompt(),
            }
          ],
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Filter out any meals that are not in the allowed types
      const allowedTypes = {'BREAKFAST', 'LUNCH', 'SNACK', 'DINNER'};
      if (json['meals'] != null) {
        json['meals'] = (json['meals'] as List)
            .where((m) => allowedTypes.contains(m['type']))
            .toList();
      }

      final resultCtrl = Get.find<AiNutritionistResultController>();
      resultCtrl.dailyCalories.value = 0;
      resultCtrl.meals.clear();
      resultCtrl.goal = selectedGoal.value;
      resultCtrl.activityLevel = activityLabel;
      resultCtrl.loadFromGroq(json);

      Get.toNamed('/ai-nutritionist-result');
    } on DioException catch (e) {
      errorMessage.value = 'Network error. Please try again.';
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===== VIEW SAVED PLAN — GET API =====
  Future<void> viewSavedPlan() async {
    try {
      isLoadingSaved.value = true;

      final ApiResponse response = await _api.getNutritionPlan();
      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        final data = message['data'] as Map<String, dynamic>;
        final resultCtrl = Get.find<AiNutritionistResultController>();
        resultCtrl.dailyCalories.value = 0;
        resultCtrl.meals.clear();
        resultCtrl.loadFromApi(data);
        Get.toNamed('/ai-nutritionist-result');
      } else {
        Get.snackbar(
          'No Plan Found',
          message?['message'] ?? 'No saved plan found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isLoadingSaved.value = false;
    }
  }

  String _buildPrompt() {
    return '''
Generate a personalized Indian diet plan for:
- Goal: ${selectedGoal.value}
- Diet Type: ${selectedFood.value}
- Activity Level: $activityLabel
- Allergies: ${allAllergies.isEmpty ? 'None' : allAllergies.join(', ')}

STRICT RULE: The "type" field in each meal must be EXACTLY one of these 4 values only: "BREAKFAST", "LUNCH", "SNACK", "DINNER". Do NOT use any other values. No "POST WORKOUT", no "BEFORE BED SNACK", nothing else. Only these 4 types are allowed.

Return ONLY this exact JSON format, nothing else:
{
  "daily_calories": 1800,
  "summary": "Based on your profile, you need 1,800 Calories to achieve your goal.",
  "tagline": "This plan is optimized for fat loss with muscle retention.",
  "meals": [
    {
      "type": "BREAKFAST",
      "time": "8:30 AM",
      "calories": 450,
      "name": "Poha with Peanuts + 1 Cup Tea",
      "tags": ["Low Fat", "Quick Prep"]
    },
    {
      "type": "LUNCH",
      "time": "1:30 PM",
      "calories": 650,
      "name": "2 Multigrain Roti + Dal Tadka + Salad",
      "tags": ["High Fiber", "Iron Rich"]
    },
    {
      "type": "SNACK",
      "time": "5:00 PM",
      "calories": 250,
      "name": "Green Tea + Roasted Makhana",
      "tags": ["Antioxidants"]
    },
    {
      "type": "DINNER",
      "time": "8:30 PM",
      "calories": 500,
      "name": "Grilled Paneer Salad / Dal Khichdi",
      "tags": ["High Protein", "Easy Digest"]
    }
  ]
}
''';
  }
}
