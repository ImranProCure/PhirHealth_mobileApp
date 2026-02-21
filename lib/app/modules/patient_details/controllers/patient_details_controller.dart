import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientDetailsController extends GetxController {
  // ===== PATIENT SELECTION =====
  final RxInt selectedPatientIndex = 0.obs;

  final RxList<Map<String, dynamic>> patients = <Map<String, dynamic>>[
    {"relation": "Myself", "name": "Rahul"},
    {"relation": "Father", "name": "Rakesh"},
  ].obs;

  void selectPatient(int index) {
    selectedPatientIndex.value = index;
  }

  // ===== ADD MEMBER DIALOG =====
  final addNameController = TextEditingController();
  final addRelationController = TextEditingController();

  void showAddMemberDialog() {
    addNameController.clear();
    addRelationController.clear();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Member",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addRelationController,
                style: const TextStyle(fontFamily: 'Mulish', fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Relation (e.g. Mother, Wife)",
                  hintStyle: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addNameController,
                style: const TextStyle(fontFamily: 'Mulish', fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF0D9488)),
                      ),
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Add button - gradient
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (addNameController.text.trim().isNotEmpty &&
                              addRelationController.text.trim().isNotEmpty) {
                            patients.add({
                              "relation": addRelationController.text.trim(),
                              "name": addNameController.text.trim(),
                            });
                            selectedPatientIndex.value = patients.length - 1;
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== FORM FIELDS =====
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final allergiesController = TextEditingController();

  final RxString selectedGender = 'Male'.obs;
  final List<String> genders = ['Male', 'Female', 'Other'];

  // ===== SYMPTOMS =====
  final List<String> symptoms = [
    'Fever',
    'Stomach Pain',
    'Lose motion',
    'Cold/Cough',
    'Headache',
  ];

  final RxList<String> selectedSymptoms = <String>[].obs;

  void toggleSymptom(String symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
  }

  // ===== NEXT STEP =====
  void goToNext() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter full name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF3F4F6),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter mobile number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF3F4F6),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    // Get.toNamed(Routes.CONFIRMATION);
    Get.snackbar(
      "Booking Confirmed!",
      "Your appointment has been booked successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    allergiesController.dispose();
    addNameController.dispose();
    addRelationController.dispose();
    super.onClose();
  }
}
