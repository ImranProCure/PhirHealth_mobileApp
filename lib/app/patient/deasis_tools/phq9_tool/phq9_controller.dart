import 'package:get/get.dart';

class Phq9Controller extends GetxController {
  // ─────────────────────────────────────────────────────────────
  // Questions
  // ─────────────────────────────────────────────────────────────

  final List<String> questions = [
    'Little interest or pleasure in doing things?',
    'Feeling down, depressed, or hopeless?',
    'Trouble falling or staying asleep, or sleeping too much?',
    'Feeling tired or having little energy?',
    'Poor appetite or overeating?',
    'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
    'Trouble concentrating on things, such as reading the newspaper or watching television?',
    'Moving or speaking so slowly that other people could have noticed? Or so fidgety or restless that you have been moving a lot more than usual?',
    'Thoughts that you would be better off dead, or thoughts of hurting yourself in some way?',
  ];

  // ─────────────────────────────────────────────────────────────
  // Answer Options
  // ─────────────────────────────────────────────────────────────

  final List<Map<String, dynamic>> answerOptions = [
    {'label': 'Not at all', 'score': 0},
    {'label': 'Several days', 'score': 1},
    {'label': 'More than half the days', 'score': 2},
    {'label': 'Nearly every day', 'score': 3},
  ];

  // ─────────────────────────────────────────────────────────────
  // Selected Answers  (null = not yet answered)
  // ─────────────────────────────────────────────────────────────

  final RxList<int?> selectedAnswers = List<int?>.filled(9, null).obs;

  void selectAnswer(int questionIndex, int score) {
    selectedAnswers[questionIndex] = score;
    selectedAnswers.refresh();
  }

  String answerLabel(int questionIndex) {
    final score = selectedAnswers[questionIndex];
    if (score == null) return 'Select';
    final opt = answerOptions.firstWhere((o) => o['score'] == score);
    final sign = score > 0 ? '+$score' : '$score';
    return '${opt['label']} - $sign';
  }

  // ─────────────────────────────────────────────────────────────
  // Validation error
  // ─────────────────────────────────────────────────────────────

  final RxBool showError = false.obs;

  // ─────────────────────────────────────────────────────────────
  // Results
  // ─────────────────────────────────────────────────────────────

  final RxInt totalScore = 0.obs;

  // ─────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────

  void onContinueFromInfo() => Get.toNamed('/phq9-form');

  void onCalculate() {
    if (selectedAnswers.any((a) => a == null)) {
      showError.value = true;
      return;
    }
    showError.value = false;
    totalScore.value =
        selectedAnswers.fold(0, (sum, v) => sum + (v ?? 0));
    Get.toNamed('/phq9-result');
  }

  // ─────────────────────────────────────────────────────────────
  // Score helpers
  // ─────────────────────────────────────────────────────────────

  String get severityLabel {
    final s = totalScore.value;
    if (s <= 4) return 'Minimal';
    if (s <= 9) return 'Mild';
    if (s <= 14) return 'Moderate';
    if (s <= 19) return 'Moderately Severe';
    return 'Severe';
  }

  String get severitySubtitle {
    final s = totalScore.value;
    if (s <= 4) return 'Minimal or no depression';
    if (s <= 9) return 'Mild depression';
    if (s <= 14) return 'Moderate Severity';
    if (s <= 19) return 'Moderately Severe Severity';
    return 'Severe Severity';
  }

  String get assessmentText => 'PHQ-9 Assessment: $severityLabel';

  String get scoreDifficultyText {
    final s = totalScore.value;
    if (s <= 4) return 'No significant difficulty reported.';
    if (s <= 9) return 'Minor difficulty with daily activities.';
    if (s <= 14) return 'Problems made it difficult to our tasks, or social life';
    if (s <= 19) return 'Significant difficulty with work and social life.';
    return 'Extreme difficulty — unable to function normally.';
  }

  String get interpretationText {
    final s = totalScore.value;
    if (s <= 4)
      return 'A score of $s indicates minimal or no depression symptoms.';
    if (s <= 9)
      return 'A score of $s indicates mild depression symptoms with minor impact.';
    if (s <= 14)
      return 'A score of $s indicates moderate depression symptoms affecting daily function.';
    if (s <= 19)
      return 'A score of $s indicates moderately severe depression. Clinical attention recommended.';
    return 'A score of $s indicates severe depression. Immediate clinical evaluation needed.';
  }

  // Active score-range index for the header bar (0–4)
  int get activeBand {
    final s = totalScore.value;
    if (s <= 4) return 0;
    if (s <= 9) return 1;
    if (s <= 14) return 2;
    if (s <= 19) return 3;
    return 4;
  }
}
