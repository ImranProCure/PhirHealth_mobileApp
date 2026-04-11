import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancergeneralAssessmentController extends GetxController {
  late String area;
  late String gender;

  final RxInt currentQuestion = 0.obs;
  final RxString selectedAnswer = ''.obs;
  final List<String> answers = [];

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Do you feel persistent fatigue or weakness without a clear reason?.',
      'subtitle': 'Please answer honestly for accurate AI analysis.',
      'options': ['Yes, Frequently', 'Occasionally', 'No, Never'],
      'imagePath': 'assets/icons/Mask group copy 4.png',
    },
    {
      'question':
          'Do you have any persistent pain (any part of the body) lasting more than 2-3 weeks?',
      'subtitle':
          'This is a critical symptom for analysis, Please answer carefully.',
      'options': ['Yes, Frequently', 'Occasionally', 'No, Never'],
      'imagePath': 'assets/icons/Mask group-1.png',
    },
    {
      'question':
          'Have you noticed any unusual lumps or swelling anywhere in your body?',
      'subtitle': 'Lifestyle and genetics play a major role in risk analysis.',
      'options': ['Yes, I have', 'No, never', 'Not sure'],
      'imagePath': 'assets/icons/Mask group-2.png',
    },
    {
      'question':
          'Do you have recurring fever or infections without a clear cause?',
      'subtitle': 'Lifestyle and genetics play a major role in risk analysis.',
      'options': ['Yes, Frequently', 'Occasionally', 'No, Never'],
      'imagePath': 'assets/icons/Mask group-2.png',
    },
  ];

  bool get isLastQuestion => currentQuestion.value == questions.length - 1;

  @override
  void onInit() {
    super.onInit();
    area = Get.arguments?['area'] ?? 'General Risk';
    gender = Get.arguments?['gender'] ?? 'Male';
  }

  void selectAnswer(String ans) => selectedAnswer.value = ans;

  void goNext() {
    if (selectedAnswer.value.isEmpty) {
      Get.snackbar(
        'Select Answer',
        'Please select an answer to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    answers.add(selectedAnswer.value);
    selectedAnswer.value = '';

    if (!isLastQuestion) {
      currentQuestion.value++;
    } else {
      Get.toNamed('/cancer-result', arguments: {
        'area': area,
        'answers': answers,
      });
    }
  }

  void goBack() {
    if (currentQuestion.value > 0) {
      currentQuestion.value--;
      if (answers.isNotEmpty) answers.removeLast();
      selectedAnswer.value = '';
    } else {
      Get.back();
    }
  }

  Map<String, dynamic> get current => questions[currentQuestion.value];
}
