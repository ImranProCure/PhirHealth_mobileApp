import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BmiResultController extends GetxController {
  late String gender;
  late int age;
  late String height;
  late int weight;
  late double bmi;
  late String category;
  late Color categoryColor;
  late double targetWeight;
  late double weightLoss;
  late double sliderPosition;

  @override
  void onInit() {
    super.onInit();
    gender = Get.arguments?['gender'] ?? 'Male';
    age = Get.arguments?['age'] ?? 28;
    height = Get.arguments?['height'] ?? "5'9";
    weight = Get.arguments?['weight'] ?? 110;
    _calculate();
  }

  void _calculate() {
    // Convert height to meters (5'9 = 1.75m approx)
    double heightM = _heightToMeters(height);
    bmi = weight / (heightM * heightM);
    bmi = double.parse(bmi.toStringAsFixed(1));

    if (bmi < 18.5) {
      category = 'Underweight';
      categoryColor = const Color(0xFF60A5FA);
      sliderPosition = 0.1;
    } else if (bmi < 25) {
      category = 'Normal';
      categoryColor = const Color(0xFF4ADE80);
      sliderPosition = 0.35;
    } else if (bmi < 30) {
      category = 'Overweight';
      categoryColor = const Color(0xFFFBBF24);
      sliderPosition = 0.62;
    } else {
      category = 'Obese';
      categoryColor = const Color(0xFFEF4444);
      sliderPosition = 0.9;
    }

    double heightM2 = _heightToMeters(height);
    targetWeight =
        double.parse((24.9 * heightM2 * heightM2).toStringAsFixed(1));
    weightLoss = double.parse((weight - targetWeight).toStringAsFixed(1));
  }

  double _heightToMeters(String h) {
    try {
      h = h.replaceAll("'", " ").replaceAll('"', '');
      final parts = h.trim().split(RegExp(r'\s+'));
      int feet = int.parse(parts[0]);
      int inches = parts.length > 1 ? int.parse(parts[1]) : 0;
      return (feet * 12 + inches) * 0.0254;
    } catch (_) {
      return 1.75;
    }
  }

  void viewPlan() {}
}
