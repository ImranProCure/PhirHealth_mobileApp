import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';

class ExperienceEditController extends GetxController {
  final Api api = Api.instance;

  /// ================= LOADING =================
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString _email = ''.obs;
  final RxString _mobile = ''.obs;

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
    _fetchProfile();
  }

  /// ================= GET CARE EXPERIENCES =================
  Future<void> fetchCareExperiences() async {
    try {
      final ApiResponse response =
          await api.commonApi.authenticationApi.getCareExperience();

      if (response.status) {
        final List data = response.data['message']['data'] ?? [];
        careExperiences.assignAll(
          data.map((e) => e['care_experience'].toString()).toList(),
        );
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  /// ================= TOGGLE PRACTICE PLACE =================
  void togglePracticePlace(
    String value,
  ) {
    if (selectedPracticePlaces.contains(value)) {
      selectedPracticePlaces.remove(value);
    } else {
      selectedPracticePlaces.add(value);
    }

    print(
      selectedPracticePlaces,
    );
  }

  /// ================= TOGGLE CARE EXPERIENCE =================
  void toggleCareExperience(String value) {
    if (selectedCareExperience.contains(value)) {
      selectedCareExperience.remove(value);
    } else {
      selectedCareExperience.add(value);
    }
    print("CARE => $selectedCareExperience");
  }

  /// ================= ADD OTHER CARE EXPERIENCE =================
  Future<void> addOtherCareExperience() async {
    final text = otherCareController.text.trim();
    if (text.isEmpty) return;

    final ApiResponse response =
        await api.commonApi.authenticationApi.createCareExperience(name: text);

    if (response.status) {
      if (!careExperiences.contains(text)) careExperiences.add(text);
      if (!selectedCareExperience.contains(text))
        selectedCareExperience.add(text);
      otherCareController.clear();
      Get.back();
      showMessage('Care experience added');
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: addOtherCareExperience,
                child: const Text("Add"),
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
      showError('Primary specialty is required');
      return false;
    }
    if (selectedPracticePlaces.isEmpty) {
      showError('Please select practice place');
      return false;
    }
    if (selectedCareExperience.isEmpty) {
      showError('Please select care experience');
      return false;
    }
    return true;
  }

  /// ================= GET DOCTOR PROFILE =================
  Future<void> _fetchProfile() async {
    try {
      isLoading.value = true;

      final ApiResponse response =
          await api.commonApi.authenticationApi.getDoctorProfile();

      final data = response.data;
      final message = data['message'];

      if (message != null && message['status'] == true) {
        final msgData = message['data'] as Map<String, dynamic>? ?? {};
        final doctor = msgData['doctor'] as Map<String, dynamic>? ?? {};
        final user = msgData['user'] as Map<String, dynamic>? ?? {};

        _email.value = user['email']?.toString() ?? '';
        _mobile.value = user['mobile_no']?.toString() ?? '';

        // ===== TOTAL EXPERIENCE =====
        totalExperience.value = double.tryParse(
                doctor['custom_total_experience']?.toString() ?? '0') ??
            0;

        // ===== PRIMARY SPECIALTY =====
        specialtyController.text =
            doctor['custom_primary_speciality']?.toString() ?? '';

        // ===== PRACTICE PLACES =====
        final places = doctor['custom_current_practice_place'];
        if (places is List) {
          selectedPracticePlaces.assignAll(List<String>.from(places));
        }

        // ===== CARE EXPERIENCE =====
        final care = doctor['custom_care_experience'];
        if (care is List) {
          selectedCareExperience.assignAll(List<String>.from(care));
        }

        // ===== HISTORY =====
        historyController.text =
            doctor['custom_gynaecological_history']?.toString() ?? '';
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= UPDATE EXPERIENCE =================
  Future<void> updateExperience() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;

      final Map<String, dynamic> fields = {
        'email': _email.value,
        'mobile_no': _mobile.value,
        'custom_total_experience': totalExperience.value.toInt().toString(),
        'custom_primary_speciality': specialtyController.text.trim(),
        'custom_current_practice_place': selectedPracticePlaces.toList(),
        'custom_care_experience': selectedCareExperience.toList(),
        'custom_gynaecological_history': historyController.text.trim(),
      };

      final ApiResponse response =
          await api.commonApi.authenticationApi.updateDoctorProfile(
        fields: fields,
      );

      if (response.status) {
        showMessage('Experience updated successfully');
        Get.back();
      } else {
        showError(response.message);
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  /// ================= DISPOSE =================
  @override
  void onClose() {
    specialtyController.dispose();
    historyController.dispose();
    otherCareController.dispose();
    super.onClose();
  }
}
