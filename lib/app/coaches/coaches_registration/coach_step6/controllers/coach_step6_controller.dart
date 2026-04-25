import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoachStep6Controller extends GetxController {
  // Client Intake Questions — index : selected
  final List<String> intakeQuestions = [
    'What specifically brought you to seek support now?',
    'If a miracle happened overnight, how would you know?',
    'What are the top 3 goals you want to achieve?',
    'What does absolute success look like to you?',
    'How will your life/career look different after goals are met?',
  ];

  // Default: all selected except index 3
  late final RxSet<int> selectedQuestions;

  // Success Story
  final successStoryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    selectedQuestions = <int>{0, 1, 2, 4}.obs;
  }

  void toggleQuestion(int index) {
    if (selectedQuestions.contains(index)) {
      selectedQuestions.remove(index);
    } else {
      selectedQuestions.add(index);
    }
  }

  void submitApplication() {
    // TODO: API submit
    Get.offAllNamed('/select-facility-type');
  }

  @override
  void onClose() {
    successStoryController.dispose();
    super.onClose();
  }
}
