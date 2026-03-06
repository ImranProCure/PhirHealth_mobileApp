import 'package:get/get.dart';

class AiNutritionistResultController extends GetxController {
  final List<Map<String, dynamic>> meals = [
    {
      'type': 'BREAKFAST',
      'time': '8:30 AM',
      'cal': '450 Cal',
      'meal': 'Poha with Peanuts + 1 Cup Tea',
      'tags': ['Low Fat', 'Quick Prep'],
      'imagePath': 'assets/icons/bakery_dining.png',
      'iconColor': 0xFFFF6B35,
      'iconBg': 0xFFFFF3EE,
    },
    {
      'type': 'LUNCH',
      'time': '1:30 PM',
      'cal': '650 Cal',
      'meal': '2 Multigrain Roti + Dal Tadka + Salad',
      'tags': ['High Fiber', 'Iron Rich'],
      'imagePath': 'assets/icons/washoku.png',
      'iconColor': 0xFF0D9488,
      'iconBg': 0xFFE0F2F1,
    },
    {
      'type': 'SNACK',
      'time': '5:00 PM',
      'cal': '250 Cal',
      'meal': 'Green Tea + Roasted Makhana',
      'tags': ['Antioxidants'],
      'imagePath': 'assets/icons/local_cafe.png',
      'iconColor': 0xFFE91E8C,
      'iconBg': 0xFFFCE4F3,
    },
    {
      'type': 'DINNER',
      'time': '8:30 PM',
      'cal': '500 Cal',
      'meal': 'Grilled Paneer Salad / Dal Khichdi',
      'tags': ['High Protein', 'Easy Digest'],
      'imagePath': 'assets/icons/soup_kitchen.png',
      'iconColor': 0xFF7C3AED,
      'iconBg': 0xFFF3E8FF,
    },
  ];

  void acceptPlan() => Get.toNamed('/dashboard');
  void regenerate() => Get.back();
}
