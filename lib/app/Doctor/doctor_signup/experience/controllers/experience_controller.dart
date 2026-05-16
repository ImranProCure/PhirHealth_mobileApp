import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

import '../../../../routes/app_routes.dart';

class ExperienceController extends GetxController {
  final Api api = Api.instance;

  /// ================= LOADING =================
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  /// ================= EXPERIENCE =================
  final RxDouble totalExperience = 0.0.obs;

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
  final RxList<String> careExperiences = <String>[].obs;

  final RxList<String> selectedCareExperience = <String>[].obs;

  /// ================= OTHER CARE EXPERIENCE =================
  final TextEditingController otherCareController = TextEditingController();

  /// ================= HISTORY =================
  final TextEditingController historyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    fetchCareExperiences();
    // fetchDoctorExperience();
  }

  /// ================= GET CARE EXPERIENCES =================
  Future<void> fetchCareExperiences() async {
    try {
      final ApiResponse response =
          await api.commonApi.authenticationApi.getCareExperience();

      if (response.status) {
        final List data = response.data['message']['data'] ?? [];

        careExperiences.assignAll(
          data
              .map(
                (e) => e['care_experience'].toString(),
              )
              .toList(),
        );
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  /// ================= GET DOCTOR EXPERIENCE =================
  // Future<void> fetchDoctorExperience() async {
  //   try {
  //     isLoading.value = true;

  //     final ApiResponse response =
  //         await api.commonApi.authenticationApi.getDoctorExperience();

  //     if (response.status) {
  //       final data = response.data['message']['data'];

  //       totalExperience.value = double.tryParse(
  //             data['total_experience'].toString(),
  //           ) ??
  //           0;

  //       specialtyController.text = data['primary_specialty'] ?? '';

  //       historyController.text = data['history'] ?? '';

  //       selectedPracticePlaces.assignAll(
  //         List<String>.from(
  //           data['practice_places'] ?? [],
  //         ),
  //       );

  //       selectedCareExperience.assignAll(
  //         List<String>.from(
  //           data['care_experience'] ?? [],
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     showError(e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// ================= TOGGLE PRACTICE PLACE =================
  void togglePracticePlace(String value) {
    if (selectedPracticePlaces.contains(value)) {
      selectedPracticePlaces.remove(value);
    } else {
      selectedPracticePlaces.add(value);
    }
  }

  /// ================= TOGGLE CARE EXPERIENCE =================
  void toggleCareExperience(String value) {
    if (selectedCareExperience.contains(value)) {
      selectedCareExperience.remove(value);
    } else {
      selectedCareExperience.add(value);
    }
  }

  /// ================= ADD OTHER CARE EXPERIENCE =================
  Future<void> addOtherCareExperience() async {
    final text = otherCareController.text.trim();

    if (text.isEmpty) {
      return;
    }

    final ApiResponse response =
        await api.commonApi.authenticationApi.createCareExperience(
      name: text,
    );

    if (response.status) {
      if (!careExperiences.contains(text)) {
        careExperiences.add(text);
      }

      if (!selectedCareExperience.contains(text)) {
        selectedCareExperience.add(text);
      }

      otherCareController.clear();

      Get.back();

      showMessage(
        'Care experience added',
      );
    } else {
      showError(response.message);
    }
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
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(
                  12,
                ),
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
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: addOtherCareExperience,
                child: const Text(
                  "Add",
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
    if (specialtyController.text.trim().isEmpty) {
      showError(
        'Primary specialty is required',
      );
      return false;
    }

    if (selectedPracticePlaces.isEmpty) {
      showError(
        'Please select practice place',
      );
      return false;
    }

    if (selectedCareExperience.isEmpty) {
      showError(
        'Please select care experience',
      );
      return false;
    }

    return true;
  }

  /// ================= SUBMIT EXPERIENCE =================
  // Future<void> submitExperience() async {
  //   if (!validateForm()) {
  //     return;
  //   }

  //   try {
  //     isSubmitting.value = true;

  //     final Map<String, dynamic> body = {
  //       "total_experience": totalExperience.value,
  //       "primary_specialty": specialtyController.text.trim(),
  //       "practice_places": selectedPracticePlaces,
  //       "care_experience": selectedCareExperience,
  //       "history": historyController.text.trim(),
  //     };

  //     final ApiResponse response =
  //         await api.commonApi.authenticationApi.saveDoctorExperience(
  //       data: body,
  //     );

  //     if (response.status) {
  //       showMessage(
  //         'Experience saved successfully',
  //       );

  //       goToNextStep();
  //     } else {
  //       showError(response.message);
  //     }
  //   } catch (e) {
  //     showError(e.toString());
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }

  /// ================= NEXT =================
  void goToNextStep() {
    Get.toNamed(
      Routes.DOCTOR_DIGITAL_READINESS,
    );
  }

  @override
  void onClose() {
    specialtyController.dispose();
    historyController.dispose();
    otherCareController.dispose();

    super.onClose();
  }
}
