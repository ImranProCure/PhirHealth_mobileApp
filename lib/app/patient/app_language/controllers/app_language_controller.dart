import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLanguageController extends GetxController {
  final RxString selectedLanguage = 'English'.obs;

  final List<Map<String, dynamic>> languages = [
    {
      'name': 'English',
      'label': 'EN',
      'bg': 0xFFEFF6FF,
      'textColor': 0xFF3B82F6
    },
    {'name': 'Hindi', 'label': 'अ', 'bg': 0xFFF5F3FF, 'textColor': 0xFF8B5CF6},
    {
      'name': 'Marathi',
      'label': 'ळ',
      'bg': 0xFFFFF7ED,
      'textColor': 0xFFF97316
    },
  ];

  void selectLanguage(String lang) => selectedLanguage.value = lang;

  void updateLanguage() {
    Get.back();
    Get.snackbar(
      'Language Updated',
      'App language set to ${selectedLanguage.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
