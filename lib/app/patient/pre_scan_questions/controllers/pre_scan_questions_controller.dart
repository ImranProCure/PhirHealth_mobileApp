import 'package:get/get.dart';

class PreScanQuestionsController extends GetxController {
  final List<String> questions = [
    'Have you exercised or done any heavy physical activity in the last 15 minutes?',
    'Have you consumed caffeine, alcohol, or smoked in the past 2 hours?',
    'Are you currently feeling unusually stressed, anxious, or fatigued?',
    'Are you wearing glasses, heavy makeup, or thick face cream right now?',
  ];

  // Each question: true = Yes selected, false = No selected, null = nothing selected
  final RxList<bool?> answers = <bool?>[true, false, true, true].obs;

  void selectAnswer(int questionIndex, bool answer) {
    answers[questionIndex] = answer;
  }

  void nextStep() => Get.toNamed('/face-scan');
}
