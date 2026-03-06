import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiNutritionistController extends GetxController {
  final RxString selectedGoal = 'Weight Loss'.obs;
  final RxString selectedFood = 'Vegetarian'.obs;
  final RxInt activityLevel =
      3.obs; // 0=Sedentary,1=Lightly,2=Moderate,3=Active,4=Very Active
  final RxList<String> selectedAllergies = <String>['Peanuts'].obs;

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
  final RxList<String> customAllergies = <String>[].obs;

  void selectGoal(String g) => selectedGoal.value = g;
  void selectFood(String f) => selectedFood.value = f;
  void setActivity(int i) => activityLevel.value = i;

  void toggleAllergy(String a) {
    if (selectedAllergies.contains(a)) {
      selectedAllergies.remove(a);
    } else {
      selectedAllergies.add(a);
    }
  }

  void addCustomAllergy(String a) => customAllergies.add(a);
  void removeCustomAllergy(String a) => customAllergies.remove(a);

  void generatePlan() => Get.toNamed('/ai-nutritionist-result');
}
