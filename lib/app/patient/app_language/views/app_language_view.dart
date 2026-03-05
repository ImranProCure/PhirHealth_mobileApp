import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_language_controller.dart';

class AppLanguageView extends GetView<AppLanguageController> {
  const AppLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'App Language',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose your preferred language',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Column(
                        children: controller.languages.map((lang) {
                          final bool isSelected =
                              controller.selectedLanguage.value == lang['name'];
                          return GestureDetector(
                            onTap: () => controller
                                .selectLanguage(lang['name'] as String),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Language icon box
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(lang['bg'] as int),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        lang['label'] as String,
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color(lang['textColor'] as int),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      lang['name'] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  // Radio
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? const Color(0xFF0D9488)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF0D9488)
                                            : const Color(0xFFD1D5DB),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check,
                                            size: 13, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),
          ),

          // ===== UPDATE BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: controller.updateLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Update Language',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
