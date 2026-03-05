import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bmi_result_controller.dart';

class BmiResultView extends GetView<BmiResultController> {
  const BmiResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D7377), Color(0xFF0D5C8A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== APP BAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Text(
                        'BMI Analysis',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: [
                      _bmiScoreCard(),
                      const SizedBox(height: 16),
                      _weightGoalCard(),
                      const SizedBox(height: 16),
                      _infoCard(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D7377), Color(0xFF0D5C8A)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: controller.viewPlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              'View Personalized Plan',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D7377),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== BMI SCORE CARD =====
  Widget _bmiScoreCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D5C6E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _BmiCirclePainter(bmi: controller.bmi),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'YOUR BMI',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white60,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.bmi}',
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '-1.2 Since May',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'CURRENT STATUS',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Category: ',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: controller.category,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: controller.categoryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Gradient slider
          SizedBox(
            height: 20,
            child: CustomPaint(
              painter: _SliderPainter(position: controller.sliderPosition),
              size: const Size(double.infinity, 20),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['UNDERWEIGHT', 'NORMAL', 'OVERWEIGHT', 'OBESE']
                .map((l) => Text(
                      l,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 9,
                        fontWeight: l == controller.category.toUpperCase()
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: l == controller.category.toUpperCase()
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ===== WEIGHT GOAL CARD =====
  Widget _weightGoalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D5C6E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/Frame 21 copy.png',
                width: 44,
                height: 44,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.fitness_center_outlined,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Weight Loss Goal',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Target weight
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A4A5C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TARGET WEIGHT',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white60,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${controller.targetWeight}',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(
                              text: ' KG',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Weight loss
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WEIGHT LOSS',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${controller.weightLoss}',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(
                              text: ' KG',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== INFO CARD =====
  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D5C6E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/Group 219 copy.png',
            width: 32,
            height: 32,
            errorBuilder: (_, __, ___) => Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0D9488), width: 1.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline,
                  color: Color(0xFF0D9488), size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                      text: 'Your BMI is calculated based on a height of '),
                  TextSpan(
                    text: controller.height,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const TextSpan(text: ' and current weight of '),
                  TextSpan(
                    text: '${controller.weight}kg',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== PAINTERS =====
class _BmiCirclePainter extends CustomPainter {
  final double bmi;
  const _BmiCirclePainter({required this.bmi});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final double progress = (bmi / 40).clamp(0.0, 1.0);
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4ADE80), Color(0xFF0D9488)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_BmiCirclePainter old) => old.bmi != bmi;
}

class _SliderPainter extends CustomPainter {
  final double position;
  const _SliderPainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 4, size.width, 8),
      const Radius.circular(4),
    );
    final barPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF60A5FA),
          Color(0xFF4ADE80),
          Color(0xFFFBBF24),
          Color(0xFFEF4444),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 8));
    canvas.drawRRect(barRect, barPaint);

    final dotX = size.width * position;
    canvas.drawCircle(Offset(dotX, 8), 8, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_SliderPainter old) => old.position != position;
}
