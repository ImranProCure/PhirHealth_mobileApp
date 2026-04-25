import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicExpertiseController extends GetxController {
  // Consultation Type: 'inperson' | 'online' | 'both'
  final RxString selectedConsultationType = 'inperson'.obs;

  // Specializations — dynamic chip list
  final RxList<String> specializations = <String>[
    'Paediatrics',
    'Dermatology',
    'Cardiology',
  ].obs;

  final TextEditingController specializationInputController =
      TextEditingController();

  void selectConsultationType(String type) {
    selectedConsultationType.value = type;
  }

  void addSpecialization(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !specializations.contains(trimmed)) {
      specializations.add(trimmed);
    }
    specializationInputController.clear();
  }

  void removeSpecialization(String value) {
    specializations.remove(value);
  }

  void goToNext() {
    Get.toNamed('/operation-appointment');
  }

  @override
  void onClose() {
    specializationInputController.dispose();
    super.onClose();
  }
}
