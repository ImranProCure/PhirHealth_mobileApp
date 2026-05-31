import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'phq9_controller.dart';

class Phq9FormView extends GetView<Phq9Controller> {
  const Phq9FormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'PHQ-9',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Ask the patient',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'how often have they been bothered by the following over the past 2 weeks?',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Validation error banner
                  Obx(() {
                    if (!controller.showError.value) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.4),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xFFEF4444)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please answer all questions before continuing.',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Questions
                  Obx(() => Column(
                        children: List.generate(
                          controller.questions.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _QuestionDropdown(
                              question: controller.questions[i],
                              selectedLabel: controller.answerLabel(i),
                              isAnswered: controller.selectedAnswers[i] != null,
                              onTap: () => _showAnswerSheet(context, i),
                            ),
                          ),
                        ),
                      )),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Calculate Button
          _CalculateButton(onTap: controller.onCalculate),
        ],
      ),
    );
  }

  void _showAnswerSheet(BuildContext context, int questionIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AnswerBottomSheet(
        questionIndex: questionIndex,
        controller: controller,
      ),
    );
  }
}

// ─── Question Dropdown Tile ───────────────────────────────────────────────────

class _QuestionDropdown extends StatelessWidget {
  final String question;
  final String selectedLabel;
  final bool isAnswered;
  final VoidCallback onTap;

  const _QuestionDropdown({
    required this.question,
    required this.selectedLabel,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAnswered
                    ? const Color(0xFF0D9488).withOpacity(0.4)
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLabel,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight:
                        isAnswered ? FontWeight.w600 : FontWeight.w400,
                    color: isAnswered
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isAnswered
                      ? const Color(0xFF0D9488)
                      : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Answer Bottom Sheet ──────────────────────────────────────────────────────

class _AnswerBottomSheet extends StatelessWidget {
  final int questionIndex;
  final Phq9Controller controller;

  const _AnswerBottomSheet({
    required this.questionIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Question text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              controller.questions[questionIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),

          // Options
          ...controller.answerOptions.map((opt) {
            final score = opt['score'] as int;
            final label = opt['label'] as String;
            final sign = score > 0 ? '+$score' : '$score';
            final isSelected =
                controller.selectedAnswers[questionIndex] == score;

            return Obx(() {
              final sel =
                  controller.selectedAnswers[questionIndex] == score;
              return GestureDetector(
                onTap: () {
                  controller.selectAnswer(questionIndex, score);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: sel
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: sel
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF374151),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFF0D9488).withOpacity(0.1)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sign,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: sel
                                ? const Color(0xFF0D9488)
                                : const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Calculate Button ─────────────────────────────────────────────────────────

class _CalculateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CalculateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Center(
            child: Text(
              'Calculate Risk',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
