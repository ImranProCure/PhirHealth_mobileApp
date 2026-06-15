import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachStep5Controller extends GetxController {
  // Commercials
  // final feeController = TextEditingController();
  // final packageController = TextEditingController();

  // Policies
  final cancellationController = TextEditingController();
  final supportController = TextEditingController();

  // Success Measurement
  final progressController = TextEditingController();

  // Behavioural Check
  // final accountabilityController = TextEditingController();
  // final resistanceController = TextEditingController();

  final RxBool hasMentor = true.obs;

  void goToNext() => Get.toNamed('/coach-step6');

  @override
  void onClose() {
    // feeController.dispose();
    // packageController.dispose();
    cancellationController.dispose();
    supportController.dispose();
    progressController.dispose();
    // accountabilityController.dispose();
    // resistanceController.dispose();
    super.onClose();
  }
}
