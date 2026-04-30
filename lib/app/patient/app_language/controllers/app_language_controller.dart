import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common widgets/lang_toggle.dart'; // ← apna actual path confirm karo

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
  ];

  @override
  void onInit() {
    super.onInit();
    // FIX 1: Screen open hone pe isHindiGlobal se sync karo
    // Warna toggle Hindi pe ho aur yahan English selected dikhe
    selectedLanguage.value = isHindiGlobal.value ? 'Hindi' : 'English';
  }

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
    // FIX 2: Toggle bhi turant sync karo
    isHindiGlobal.value = (lang == 'Hindi');
  }

  void updateLanguage() {
    final isHindi = selectedLanguage.value == 'Hindi';
    // FIX 3: isHindiGlobal sync karo
    isHindiGlobal.value = isHindi;

    if (isHindi) {
      Get.updateLocale(const Locale('hi', 'IN'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }

    // FIX 4: pehle back, phir thodi der baad snackbar
    Get.back();

    Future.delayed(const Duration(milliseconds: 300), () {
      Get.snackbar(
        'Language Updated',
        'App language set to ${selectedLanguage.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
}
