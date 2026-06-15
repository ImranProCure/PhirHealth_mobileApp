import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachStep3Controller extends GetxController {
  // Specializations
  final List<String> specializationList = [
    'Stress Mgmt',
    'Anxiety/Depression',
    'Relationships',
    'Career',
    'Addiction',
    'Child/Teen',
    'Wellness',
  ];
  final RxSet<String> selectedSpecializations = <String>{}.obs;

  // Target Audience
  final List<String> audienceList = [
    'Adults',
    'Adolescents',
    'Couples',
    'Families',
  ];
  final RxSet<String> selectedAudience = <String>{}.obs;

  // Experience slider
  final RxDouble yearsExperience = 8.0.obs;

  // Type of Experience
  final List<String> expTypeList = ['Clinical', 'Non-Clinical', 'Coaching'];
  final RxSet<String> selectedExpTypes = <String>{}.obs;

  // Text fields
  final workplacesController = TextEditingController();
  // final avgClientsController = TextEditingController();
  // final totalHrsController = TextEditingController();

  void toggleSpecialization(String val) {
    if (selectedSpecializations.contains(val)) {
      selectedSpecializations.remove(val);
    } else {
      selectedSpecializations.add(val);
    }
  }

  void toggleAudience(String val) {
    if (selectedAudience.contains(val)) {
      selectedAudience.remove(val);
    } else {
      selectedAudience.add(val);
    }
  }

  void toggleExpType(String val) {
    if (selectedExpTypes.contains(val)) {
      selectedExpTypes.remove(val);
    } else {
      selectedExpTypes.add(val);
    }
  }

  void goToNext() => Get.toNamed('/coach-step4');

  @override
  void onClose() {
    workplacesController.dispose();
    // avgClientsController.dispose();
    // totalHrsController.dispose();
    super.onClose();
  }
}
