import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/api/common_api/ai_nutrition_api/ai_nutrition_api.dart';

class AiNutritionistResultController extends GetxController {
  final AiNutritionApi _api = AiNutritionApi();

  // ===== LOADING =====
  final RxBool isSaving = false.obs;

  // ===== FLAG =====
  final RxBool isSavedPlan = false.obs;

  // ===== DATA =====
  final RxInt dailyCalories = 0.obs;
  final RxString summary = ''.obs;
  final RxString tagline = ''.obs;
  final RxList<Map<String, dynamic>> meals = <Map<String, dynamic>>[].obs;

  // ===== GOAL + ACTIVITY =====
  String goal = '';
  String activityLevel = '';

  final Map<String, Map<String, dynamic>> _mealIconConfig = {
    'BREAKFAST': {
      'imagePath': 'assets/icons/bakery_dining.png',
      'iconColor': 0xFFFF6B35,
      'iconBg': 0xFFFFF3EE,
    },
    'LUNCH': {
      'imagePath': 'assets/icons/washoku.png',
      'iconColor': 0xFF0D9488,
      'iconBg': 0xFFE0F2F1,
    },
    'SNACK': {
      'imagePath': 'assets/icons/local_cafe.png',
      'iconColor': 0xFFE91E8C,
      'iconBg': 0xFFFCE4F3,
    },
    'SNACKS': {
      'imagePath': 'assets/icons/local_cafe.png',
      'iconColor': 0xFFE91E8C,
      'iconBg': 0xFFFCE4F3,
    },
    'DINNER': {
      'imagePath': 'assets/icons/soup_kitchen.png',
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFF3E8FF,
    },
    'BEFORE BED SNACK': {
      'imagePath': 'assets/icons/soup_kitchen.png',
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFF3E8FF,
    },
  };

  // ===== LOAD FROM GROQ =====
  void loadFromGroq(Map<String, dynamic> json) {
    isSavedPlan.value = false;
    dailyCalories.value = json['daily_calories'] ?? 0;
    summary.value = json['summary'] ?? '';
    tagline.value = json['tagline'] ?? '';

    final rawMeals = json['meals'] as List? ?? [];
    meals.value = rawMeals.map((m) {
      final type = (m['type'] as String).toUpperCase();
      final iconConfig = _mealIconConfig[type] ?? _mealIconConfig['BREAKFAST']!;
      return {
        'type': type,
        'time': m['time'] ?? '',
        'cal': '${m['calories']} Cal',
        'meal': m['name'] ?? '',
        'tags': List<String>.from(m['tags'] ?? []),
        ...iconConfig,
      };
    }).toList();
  }

  // ===== LOAD FROM API =====
  void loadFromApi(Map<String, dynamic> data) {
    isSavedPlan.value = true;

    // ✅ int safely parse karo
    final cal = data['daily_calories'];
    dailyCalories.value =
        cal is int ? cal : int.tryParse(cal?.toString() ?? '0') ?? 0;

    goal = data['goal']?.toString() ?? '';
    summary.value = 'Your saved ${data['goal']} plan';
    tagline.value = 'Tap Go Back to return';

    final rawMeals = data['meals'] as List? ?? [];
    meals.value = rawMeals.map((m) {
      final type = (m['meal_type'] as String).toUpperCase();
      final iconConfig = _mealIconConfig[type] ?? _mealIconConfig['BREAKFAST']!;

      // ✅ calories bhi safely parse karo
      final mealCal = m['calories'];
      final calInt = mealCal is int
          ? mealCal
          : int.tryParse(mealCal?.toString() ?? '0') ?? 0;

      return {
        'type': type,
        'time': m['meal_time']?.toString() ?? '',
        'cal': '$calInt Cal',
        'meal': m['food_items']?.toString() ?? '',
        'tags': List<String>.from(m['tags'] ?? []),
        ...iconConfig,
      };
    }).toList();
  }

  // ===== ACCEPT PLAN — POST API =====
  Future<void> acceptPlan() async {
    try {
      isSaving.value = true;

      final mealsForApi = meals.map((m) {
        // ✅ "450.0 Cal" bhi handle hoga
        final calStr = m['cal'].toString().replaceAll(' Cal', '').trim();
        final calories = double.tryParse(calStr)?.toInt() ?? 0;

        return {
          'meal_type': m['type'],
          'meal_time': m['time'],
          'calories': calories,
          'food_items': m['meal'],
          'tags': List<String>.from(m['tags'] ?? []), // ✅ RxList se plain List
        };
      }).toList();

      final ApiResponse response = await _api.saveNutritionPlan(
        goal: goal,
        activityLevel: activityLevel,
        dailyCalories: dailyCalories.value,
        meals: mealsForApi,
        tags: [],
      );

      final message = response.data['message'];

      if (message != null && message['status'] == true) {
        showMessage('Plan saved successfully!');
        Get.offAllNamed('/dashboard');
      } else {
        showError(message?['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ===== REGENERATE / GO BACK =====
  void regenerate() {
    dailyCalories.value = 0;
    summary.value = '';
    tagline.value = '';
    meals.clear();
    isSavedPlan.value = false;
    Get.back();
  }
}
