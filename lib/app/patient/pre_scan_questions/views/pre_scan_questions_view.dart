import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pre_scan_questions_controller.dart';

class PreScanQuestionsView extends GetView<PreScanQuestionsController> {
  const PreScanQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Pre-Scan Questions',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  controller.questions.length,
                  (i) => _questionBlock(i),
                ),
              ),
            ),
          ),

          // ===== NEXT STEP BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                ),
                child: ElevatedButton(
                  onPressed: controller.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next Step',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionBlock(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(controller.questions[i],
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.4)),
          const SizedBox(height: 14),

          // Yes / No chips
          Obx(() => Row(
                children: [
                  _answerChip(i, true, 'Yes'),
                  const SizedBox(width: 12),
                  _answerChip(i, false, 'No'),
                ],
              )),
        ],
      ),
    );
  }

  Widget _answerChip(int questionIndex, bool value, String label) {
    final bool isSelected = controller.answers[questionIndex] == value;
    return GestureDetector(
      onTap: () => controller.selectAnswer(questionIndex, value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0D9488) : const Color(0xFFD1D5DB),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle check
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF0D9488) : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0D9488)
                      : const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF374151))),
          ],
        ),
      ),
    );
  }
}
