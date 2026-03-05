import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BmiController extends GetxController {
  final RxString selectedGender = 'Male'.obs;
  final RxInt age = 28.obs;
  final RxString height = '5\'9'.obs;
  final RxInt weight = 110.obs;

  final List<Map<String, dynamic>> genders = [
    {'label': 'Male', 'icon': Icons.male},
    {'label': 'Female', 'icon': Icons.female},
    {'label': 'Other', 'icon': Icons.male},
  ];

  void selectGender(String g) => selectedGender.value = g;

  void onAgeChanged(String val) {
    final int? v = int.tryParse(val);
    if (v != null) age.value = v;
  }

  void onHeightChanged(String val) => height.value = val;

  void onWeightChanged(String val) {
    final int? v = int.tryParse(val);
    if (v != null) weight.value = v;
  }

  void calculateBmi() => Get.toNamed('/bmi-result', arguments: {
        'gender': selectedGender.value,
        'age': age.value,
        'height': height.value,
        'weight': weight.value,
      });
}
