import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class DigitalReadinessController extends GetxController {
  /// ================= TECH & PROTOCOL SWITCHES =================
  final RxBool teleconsultation = false.obs;
  final RxBool emrSystems = false.obs;
  final RxBool clinicalProtocols = false.obs;
  final RxBool multidisciplinaryTeams = false.obs;

  /// ================= AVAILABILITY =================
  final TextEditingController availabilityController = TextEditingController();

  /// ================= LANGUAGES =================
  final RxList<String> languages = <String>[
    "English",
    "Hindi",
    "French",
    "Spanish",
  ].obs;

  final RxList<String> selectedLanguages = <String>[].obs;

  final TextEditingController otherLanguageController = TextEditingController();

  /// ================= CONSULTATION FEE =================
  final TextEditingController feeController = TextEditingController();

  /// ================= TOGGLE LANGUAGE =================
  void toggleLanguage(String value) {
    if (selectedLanguages.contains(value)) {
      selectedLanguages.remove(value);
    } else {
      selectedLanguages.add(value);
    }
  }

  /// ================= ADD OTHER LANGUAGE =================
  void addOtherLanguage() {
    final text = otherLanguageController.text.trim();
    if (text.isEmpty) return;

    if (!languages.contains(text)) {
      languages.add(text);
    }

    if (!selectedLanguages.contains(text)) {
      selectedLanguages.add(text);
    }

    otherLanguageController.clear();
  }

  /// ================= OPEN ADD LANGUAGE SHEET =================
  void openAddLanguageBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Language",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otherLanguageController,
              decoration: InputDecoration(
                hintText: "Enter language",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00786F),
                      Color(0xFF009689),
                      Color(0xFF1447E6),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    addOtherLanguage();
                    Get.back();
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// ================= VALIDATION =================
  bool validateForm() {
    return availabilityController.text.trim().isNotEmpty &&
        feeController.text.trim().isNotEmpty;
  }

  /// ================= NAVIGATION =================
  void goToNextStep() {
    Get.toNamed(Routes.DOCTOR_FINAL_VERIFICATION);
  }

  @override
  void onClose() {
    availabilityController.dispose();
    otherLanguageController.dispose();
    feeController.dispose();
    super.onClose();
  }
}
