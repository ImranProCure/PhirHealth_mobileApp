import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'phq9_controller.dart';

class Phq9ResultView extends GetView<Phq9Controller> {
  const Phq9ResultView({super.key});

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Assessment Result',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.share_outlined, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ── Score Card ──────────────────────────────
                    _ScoreCard(
                      score: controller.totalScore.value,
                      severity: controller.severityLabel,
                      severitySubtitle: controller.severitySubtitle,
                      activeBand: controller.activeBand,
                    ),

                    const SizedBox(height: 16),

                    // ── Clinical Interpretation Card ─────────────
                    _ClinicalInterpretationCard(
                      assessmentText: controller.assessmentText,
                      scoreDifficultyText: controller.scoreDifficultyText,
                      interpretationText: controller.interpretationText,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Action Buttons ───────────────────────────────────
           // const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

// ─── Score Card ───────────────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final int score;
  final String severity;
  final String severitySubtitle;
  final int activeBand; // 0–4

  const _ScoreCard({
    required this.score,
    required this.severity,
    required this.severitySubtitle,
    required this.activeBand,
  });

  static const _bands = [
    {'range': '0-4', 'color': Color(0xFF22C55E)},
    {'range': '5-9', 'color': Color(0xFF84CC16)},
    {'range': '10-14', 'color': Color(0xFFF59E0B)},
    {'range': '15-19', 'color': Color(0xFFF97316)},
    {'range': '20-27', 'color': Color(0xFFEF4444)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Score band bar
          Row(
            children: List.generate(_bands.length, (i) {
              final band = _bands[i];
              final isActive = i == activeBand;
              final color = band['color'] as Color;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: isActive ? 0 : 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? color : color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      band['range'] as String,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : color,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 8),

          // Low / Moderate / High labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF22C55E),
                ),
              ),
              Text(
                'Moderate',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF59E0B),
                ),
              ),
              Text(
                'High',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Score number + label
          Text(
            '$score (${_dynamicLabel(score)})',
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            severity,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            severitySubtitle,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  String _dynamicLabel(int s) {
    if (s <= 4) return 'Minimal';
    if (s <= 9) return 'Mild';
    if (s <= 14) return 'Dynamic';
    if (s <= 19) return 'Moderate';
    return 'Severe';
  }
}

// ─── Clinical Interpretation Card ────────────────────────────────────────────

class _ClinicalInterpretationCard extends StatelessWidget {
  final String assessmentText;
  final String scoreDifficultyText;
  final String interpretationText;

  const _ClinicalInterpretationCard({
    required this.assessmentText,
    required this.scoreDifficultyText,
    required this.interpretationText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clinical Interpretation',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),
          _InterpretationRow(
            icon: Icons.psychology_outlined,
            iconBgColor: const Color(0xFFFFE4E4),
            iconColor: const Color(0xFFEF4444),
            label: 'Assessment',
            value: assessmentText,
          ),
          const SizedBox(height: 16),
          _InterpretationRow(
            icon: Icons.medication_outlined,
            iconBgColor: const Color(0xFFFFEDD5),
            iconColor: const Color(0xFFF97316),
            label: 'Score Difficulty',
            value: scoreDifficultyText,
          ),
          const SizedBox(height: 16),
          _InterpretationRow(
            icon: Icons.visibility_outlined,
            iconBgColor: const Color(0xFFFFE4E4),
            iconColor: const Color(0xFFEF4444),
            label: 'Interpretation',
            value: interpretationText,
          ),
        ],
      ),
    );
  }
}

class _InterpretationRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;

  const _InterpretationRow({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        children: [
          // Primary
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF2563EB)],
                ),
              ),
              child: const Center(
                child: Text(
                  'CBT Boundaries Worksheet',
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

          const SizedBox(height: 12),

          // Secondary
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: const Color(0xFF0D9488),
                  width: 1.5,
                ),
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  'Guided Breathing Audio',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => Get.until((route) => route.isFirst),
            child: const Text(
              'Go to Home',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D9488),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
