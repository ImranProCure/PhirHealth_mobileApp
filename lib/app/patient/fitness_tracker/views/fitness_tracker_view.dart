import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fitness_tracker_controller.dart';

class FitnessTrackerView extends GetView<FitnessTrackerController> {
  const FitnessTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Your Activity',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _activityCard(),
            const SizedBox(height: 16),
            _weeklyChartCard(),
          ],
        ),
      ),
    );
  }

  // ===== ACTIVITY CARD =====
  Widget _activityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Title Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Activity',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    controller.date,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              // GestureDetector(
              //   onTap: controller.openSettings,
              //   child: const Icon(Icons.settings_outlined,
              //       color: Color(0xFF6B7280), size: 24),
              // ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Circular Progress ──
          Obx(() => SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter:
                      _StepsCirclePainter(progress: controller.progress),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatNumber(controller.steps.value),
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Steps',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'GOAL: ${_formatNumber(controller.goal)}',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          controller.status.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 11,
                            color: Color(0xFFB0B0B0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 20),

          // ── Distance & Calories (dynamic) ──
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _statCard(
                      icon: Icons.directions_run,
                      iconColor: const Color(0xFF0D9488),
                      value: '${controller.distance} km',
                      label: 'Distance',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      icon: Icons.local_fire_department_outlined,
                      iconColor: const Color(0xFFF97316),
                      value: '${controller.calories} kcal',
                      label: 'Calories',
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 12),

          // ── Dynamic Motivation Banner ──
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: controller.progress >= 1.0
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.progress >= 1.0
                          ? Icons.emoji_events
                          : Icons.emoji_events_outlined,
                      color: const Color(0xFF0D9488),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        controller.motivationText,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          //const SizedBox(height: 16),

          // // ── Share Button ──
          // SizedBox(
          //   width: double.infinity,
          //   height: 52,
          //   child: DecoratedBox(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(30),
          //       gradient: const LinearGradient(
          //         colors: [Color(0xFF00897B), Color(0xFF1565C0)],
          //       ),
          //     ),
          //     child: ElevatedButton(
          //       onPressed: controller.shareOnWhatsApp,
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.transparent,
          //         shadowColor: Colors.transparent,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(30)),
          //       ),
          //       child: const Text(
          //         'Share on WhatsApp',
          //         style: TextStyle(
          //           fontFamily: 'Mulish',
          //           fontSize: 15,
          //           fontWeight: FontWeight.w700,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ===== STAT CARD =====
  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // ===== WEEKLY CHART CARD =====
  Widget _weeklyChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          const Text(
            'Last 7 Days',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Obx(() => Text(
                'Total: ${_formatNumber(controller.totalWeekSteps)} Steps',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D9488),
                ),
              )),
          const SizedBox(height: 20),

          // ── Bar Chart ──
          _barChart(),
          const SizedBox(height: 20),

          // ── Change Goal ──
          _changeGoalSection(),
          const SizedBox(height: 12),

          // ── Recommended Banner ──
          Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border_outlined,
                        color: Color(0xFF0D9488), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Recommended for Heart Health: ${_formatNumber(controller.recommendedSteps)}',
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          color: Color(0xFF374151),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 16),

          // ── Save Goal Button ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                ),
              ),
              child: ElevatedButton(
                onPressed: controller.saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Save Goal',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== BAR CHART =====
  Widget _barChart() {
    return Obx(() {
      if (controller.weekData.isEmpty) {
        return const SizedBox(
          height: 160,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0D9488),
              strokeWidth: 2,
            ),
          ),
        );
      }

      final maxSteps = controller.weekData
          .map((d) => d['steps'] as int)
          .reduce((a, b) => a > b ? a : b);

      return SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.weekData.map((d) {
            final int steps = d['steps'] as int;
            final String colorType = d['color'] as String;
            final bool isToday = d['isToday'] as bool? ?? false;
            final double heightRatio =
                maxSteps > 0 ? steps / maxSteps : 0;

            Color barColor;
            if (colorType == 'green') {
              barColor = const Color(0xFF22C55E);
            } else if (colorType == 'orange') {
              barColor = const Color(0xFFF97316);
            } else {
              barColor = const Color(0xFFE5E7EB);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Step count label on top of today's bar
                if (isToday && steps > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      _formatNumber(steps),
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ),
                Container(
                  width: 32,
                  height: steps == 0 ? 20 : 120 * heightRatio,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(
                            color: const Color(0xFF0D9488), width: 2)
                        : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  d['day'] as String,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: isToday
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF9CA3AF),
                    fontWeight: isToday
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    });
  }

  // ===== CHANGE GOAL SECTION =====
  Widget _changeGoalSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text(
            'Change Your Daily Goal',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minus
                  GestureDetector(
                    onTap: controller.decrementGoal,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.remove,
                          color: Colors.black, size: 22),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    _formatNumber(controller.dailyGoal.value),
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Plus
                  GestureDetector(
                    onTap: controller.incrementGoal,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 6),
          const Text(
            'STEPS',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D9488),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ===== HELPER =====
  String _formatNumber(int n) {
    return n.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}

// ===== CIRCLE PAINTER =====
class _StepsCirclePainter extends CustomPainter {
  final double progress;
  const _StepsCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 14.0;

    // Background track
    final bgPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00897B), Color(0xFF1565C0)],
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
  bool shouldRepaint(_StepsCirclePainter old) => old.progress != progress;
}