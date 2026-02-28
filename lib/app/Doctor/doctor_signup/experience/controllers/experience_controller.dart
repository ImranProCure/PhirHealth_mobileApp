import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class ExperienceController extends GetxController {
  /// ================= EXPERIENCE =================
  final RxDouble totalExperience = 8.0.obs;

  /// ================= PRIMARY SPECIALTY =================
  final TextEditingController specialtyController = TextEditingController();

  /// ================= PRACTICE PLACE =================
  final RxList<String> practicePlaces = <String>[
    "Hospital",
    "Private Clinic",
    "Telemedicine",
  ].obs;

  final RxList<String> selectedPracticePlaces = <String>[].obs;

  /// ================= CARE EXPERIENCE =================
  final RxList<String> careExperiences = <String>[
    "OPD",
    "IPD",
    "Emergency",
  ].obs;

  final RxList<String> selectedCareExperience = <String>[].obs;

  /// ================= OTHER INPUT =================
  final TextEditingController otherCareController = TextEditingController();

  /// ================= HISTORY =================
  final TextEditingController historyController = TextEditingController();

  /// ================= TOGGLE HELPERS =================
  void togglePracticePlace(String value) {
    if (selectedPracticePlaces.contains(value)) {
      selectedPracticePlaces.remove(value);
    } else {
      selectedPracticePlaces.add(value);
    }
  }

  void toggleCareExperience(String value) {
    if (selectedCareExperience.contains(value)) {
      selectedCareExperience.remove(value);
    } else {
      selectedCareExperience.add(value);
    }
  }

  /// ================= ADD OTHER CARE EXPERIENCE =================
  void addOtherCareExperience() {
    final text = otherCareController.text.trim();
    if (text.isEmpty) return;

    if (!careExperiences.contains(text)) {
      careExperiences.add(text);
    }

    if (!selectedCareExperience.contains(text)) {
      selectedCareExperience.add(text);
    }

    otherCareController.clear();
  }

  /// ================= OPEN BOTTOM SHEET =================
  void openAddOtherBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Other Experience",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            /// INPUT
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: otherCareController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter here...",
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ADD BUTTON
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
                    addOtherCareExperience();
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
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// ================= VALIDATION =================
  bool validateForm() {
    return specialtyController.text.trim().isNotEmpty;
  }

  /// ================= NAVIGATION =================
  void goToNextStep() {
    Get.toNamed(Routes.DOCTOR_DIGITAL_READINESS);
  }

  @override
  void onClose() {
    specialtyController.dispose();
    historyController.dispose();
    otherCareController.dispose();
    super.onClose();
  }
}
