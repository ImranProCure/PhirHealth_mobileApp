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
    final double heightM = _heightToMeters(height);

    // BMI formula
    bmi = weight / (heightM * heightM);
    bmi = double.parse(bmi.toStringAsFixed(1));

    // Category + color + slider
    if (bmi < 18.5) {
      category = 'bmi_result_underweight'.tr;
      categoryColor = const Color(0xFF60A5FA);
    } else if (bmi < 25) {
      category = 'bmi_result_normal'.tr;
      categoryColor = const Color(0xFF4ADE80);
    } else if (bmi < 30) {
      category = 'bmi_result_overweight'.tr;
      categoryColor = const Color(0xFFFBBF24);
    } else {
      category = 'bmi_result_obese'.tr;
      categoryColor = const Color(0xFFEF4444);
    }

    // Exact slider position from BMI
    // BAAD MEIN — category zones ke hisaab se:
    if (bmi < 18.5) {
      // Underweight zone — 0.0 to 0.25
      sliderPosition = ((bmi / 18.5) * 0.25).clamp(0.0, 0.24);
    } else if (bmi < 25) {
      // Normal zone — 0.25 to 0.50
      sliderPosition = (0.25 + ((bmi - 18.5) / 6.5) * 0.25).clamp(0.25, 0.49);
    } else if (bmi < 30) {
      // Overweight zone — 0.50 to 0.75
      sliderPosition = (0.50 + ((bmi - 25) / 5) * 0.25).clamp(0.50, 0.74);
    } else {
      // Obese zone — 0.75 to 1.0
      sliderPosition = (0.75 + ((bmi - 30) / 10) * 0.25).clamp(0.75, 1.0);
    }

    // Target weight — Normal BMI upper limit (24.9)
    targetWeight = double.parse(
      (24.9 * heightM * heightM).toStringAsFixed(1),
    );

    // Weight loss — negative nahi aayega
    final double loss = weight - targetWeight;
    weightLoss = double.parse(
      loss.clamp(0.0, double.infinity).toStringAsFixed(1),
    );
  }

  // Height parse — 5'9 / 5'9" / 5 9 sab handle karta hai
  double _heightToMeters(String h) {
    try {
      h = h.replaceAll('"', '').replaceAll("'", ' ');
      final parts = h.trim().split(RegExp(r'\s+'));
      final int feet = int.tryParse(parts[0]) ?? 5;
      final int inches = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
      return (feet * 12 + inches) * 0.0254;
    } catch (_) {
      return 1.75;
    }
  }

  void viewPlan() {
    // Aage connect karna ho toh yahan
  }
}
