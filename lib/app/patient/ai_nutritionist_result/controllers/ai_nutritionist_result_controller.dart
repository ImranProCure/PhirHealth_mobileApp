import 'package:get/get.dart';

class AiNutritionistResultController extends GetxController {
  // Dynamic data from Groq
  final RxInt dailyCalories = 0.obs;
  final RxString summary = ''.obs;
  final RxString tagline = ''.obs;
  final RxList<Map<String, dynamic>> meals = <Map<String, dynamic>>[].obs;

  // Icon config per meal type — UI only, static
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
    'DINNER': {
      'imagePath': 'assets/icons/soup_kitchen.png',
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFF3E8FF,
    },
  };

  // Called by AiNutritionistController after Groq responds
  void loadFromGroq(Map<String, dynamic> json) {
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

  void acceptPlan() => Get.toNamed('/dashboard');
  void regenerate() {
    Get.back(); // AI nutritionist screen pe wapas jao
    // Purana data clear karo
    dailyCalories.value = 0;
    summary.value = '';
    tagline.value = '';
    meals.clear();
  }
}
