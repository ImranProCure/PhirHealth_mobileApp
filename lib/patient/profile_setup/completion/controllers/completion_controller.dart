import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletionController extends GetxController {
  // ================= TEXT CONTROLLERS =================

  final contactNameController = TextEditingController();
  final mobileController = TextEditingController();

  // ================= RELATIONSHIP =================

  final relationships = ['Spouse', 'Parent', 'Sibling', 'Friend'];
  final selectedRelationship = ''.obs;

  void selectRelationship(String value) {
    selectedRelationship.value = value;
  }

  // ================= CHECKBOXES =================

  final authorizeEmergency = false.obs;
  final agreePolicy = false.obs;

  void toggleAuthorize() {
    authorizeEmergency.toggle();
  }

  void toggleAgreePolicy() {
    agreePolicy.toggle();
  }

  // ================= APP PERMISSIONS =================

  final medicalDataProcessing = true.obs;
  final shareWithDoctors = true.obs;
  final healthReminders = false.obs;

  final allowMedicalProcessing = true.obs;
  final enableReminders = false.obs;

  void toggleMedicalProcessing(bool value) {
    medicalDataProcessing.value = value;
  }

  void toggleShareWithDoctors(bool value) {
    shareWithDoctors.value = value;
  }

  void toggleHealthReminders(bool value) {
    healthReminders.value = value;
  }

  final acceptTerms = false.obs;

  void toggleTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  // ================= FINAL ACTION =================

  void completeProfile() {
    if (!agreePolicy.value) {
      Get.snackbar('Required', 'Please agree to Terms & Privacy Policy');
      return;
    }

    // TODO: Navigate to Dashboard
    print('Profile Completed');
  }

  @override
  void onClose() {
    contactNameController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
