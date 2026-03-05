import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FitnessTrackerController extends GetxController {
  final String date = 'Today, 12 Feb';
  final RxInt steps = 3500.obs;
  final int goal = 5000;
  final double distance = 2.5;
  final int calories = 140;

  // Last 7 days data — true = green, false = orange, null = gray
  final List<Map<String, dynamic>> weekData = [
    {'day': 'M', 'steps': 4200, 'color': 'green'},
    {'day': 'T', 'steps': 2800, 'color': 'orange'},
    {'day': 'W', 'steps': 5100, 'color': 'green'},
    {'day': 'T', 'steps': 4800, 'color': 'green'},
    {'day': 'F', 'steps': 3200, 'color': 'orange'},
    {'day': 'S', 'steps': 4600, 'color': 'green'},
    {'day': 'S', 'steps': 0, 'color': 'gray'},
  ];

  int get totalWeekSteps =>
      weekData.fold(0, (sum, d) => sum + (d['steps'] as int));

  final RxInt dailyGoal = 5000.obs;

  double get progress => (steps.value / goal).clamp(0.0, 1.0);

  void incrementGoal() => dailyGoal.value += 500;
  void decrementGoal() {
    if (dailyGoal.value > 500) dailyGoal.value -= 500;
  }

  void saveGoal() {
    Get.back();
    Get.snackbar(
      'Goal Updated',
      'Daily goal set to ${dailyGoal.value} steps',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void shareOnWhatsApp() {}
  void openSettings() {}
}
