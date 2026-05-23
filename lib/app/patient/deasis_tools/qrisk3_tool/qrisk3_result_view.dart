import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_controller.dart';

class Qrisk3ResultView extends GetView<Qrisk3Controller> {
  const Qrisk3ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      // ─────────────────────────────────────────────
      // APP BAR
      // ─────────────────────────────────────────────

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
          'Heart Health Score',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      // ─────────────────────────────────────────────
      // BODY
      // ─────────────────────────────────────────────

      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // GAUGE CARD
                    _GaugeCard(
                      riskLevel: controller.riskLevel,
                      tenYearRisk: controller.tenYearRisk.value,
                      optimalRisk: controller.optimalRisk.value,
                      heartAge: controller.heartAge,
                      gaugeAngle: controller.gaugeAngle,
                    ),

                    const SizedBox(height: 16),

                    // RISK COMPARISON CARD
                    _RiskComparisonCard(
                      tenYearRisk: controller.tenYearRisk.value,
                      optimalRisk: controller.optimalRisk.value,
                      relativeRisk: controller.relativeRisk,
                      relativeRiskLabel: controller.relativeRiskLabel,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // BOTTOM BUTTONS
            // _BottomButtons(
            //   tenYearRisk: controller.tenYearRisk.value,
            // ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GAUGE CARD
// ─────────────────────────────────────────────────────────────

class _GaugeCard extends StatelessWidget {
  final String riskLevel;
  final double tenYearRisk;
  final double optimalRisk;
  final String heartAge;
  final double gaugeAngle;

  const _GaugeCard({
    required this.riskLevel,
    required this.tenYearRisk,
    required this.optimalRisk,
    required this.heartAge,
    required this.gaugeAngle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
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
          // GAUGE
          SizedBox(
            height: 160,
            width: 260,
            child: CustomPaint(
              painter: _GaugePainter(needleAngle: gaugeAngle),
            ),
          ),

          const SizedBox(height: 6),

          // LABELS
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Low',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF22C55E),
                  ),
                ),
                Text(
                  'Moderate',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'High',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // PERCENTAGE
          Text(
            '$tenYearRisk%',
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            '10-Year Heart Risk',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 10),

          // HEART AGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Healthy Heart Age: $heartAge',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GAUGE PAINTER
// ─────────────────────────────────────────────────────────────

class _GaugePainter extends CustomPainter {
  final double needleAngle;
  const _GaugePainter({required this.needleAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 20;
    final radius = size.width / 2 - 10;
    const strokeWidth = 20.0;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    paint.shader = SweepGradient(
      startAngle: pi,
      endAngle: 2 * pi,
      colors: const [
        Color(0xFF22C55E),
        Color(0xFFEAB308),
        Color(0xFFF97316),
        Color(0xFFEF4444),
      ],
      stops: const [0.0, 0.4, 0.7, 1.0],
    ).createShader(rect);

    canvas.drawArc(rect, pi, pi, false, paint);

    // NEEDLE
    final angle = pi + ((needleAngle + 1) / 2) * pi;
    final needleLength = radius - 14;
    final x = cx + needleLength * cos(angle);
    final y = cy + needleLength * sin(angle);

    final needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy), Offset(x, y), needlePaint);
    canvas.drawCircle(Offset(cx, cy), 10, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.needleAngle != needleAngle;
}

// ─────────────────────────────────────────────────────────────
// RISK COMPARISON CARD
// ─────────────────────────────────────────────────────────────

class _RiskComparisonCard extends StatelessWidget {
  final double tenYearRisk;
  final double optimalRisk;
  final double relativeRisk;
  final String relativeRiskLabel;

  const _RiskComparisonCard({
    required this.tenYearRisk,
    required this.optimalRisk,
    required this.relativeRisk,
    required this.relativeRiskLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            'Risk Comprarison',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          _ComparisonRow(
            icon: Icons.diamond_outlined,
            iconColor: const Color(0xFFEF4444),
            title: 'Your Score',
            value: '$tenYearRisk%',
          ),
          const SizedBox(height: 18),

          _ComparisonRow(
            icon: Icons.monitor_heart_outlined,
            iconColor: const Color(0xFFEF4444),
            title: 'Healthy Person Score',
            value: '$optimalRisk% (Same age, sex, ethnicity)',
          ),
          const SizedBox(height: 18),

          _ComparisonRow(
            icon: Icons.history,
            iconColor: const Color(0xFFEF4444),
            title: 'Relative Risk',
            value: '$relativeRisk ($relativeRiskLabel)',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPARISON ROW
// ─────────────────────────────────────────────────────────────

class _ComparisonRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _ComparisonRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTTOM BUTTONS
// ─────────────────────────────────────────────────────────────

class _BottomButtons extends StatelessWidget {
  final double tenYearRisk;
  const _BottomButtons({required this.tenYearRisk});

  String get _ctaLabel {
    if (tenYearRisk >= 20) return 'Consult a Cardiologist Immediately';
    if (tenYearRisk >= 7.5) return 'Discuss Risk with Your Doctor';
    return 'View Lifestyle Recommendations';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        children: [
          // PRIMARY CTA
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
              child: Center(
                child: Text(
                  _ctaLabel,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // DOWNLOAD REPORT
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFF0D9488), width: 1.5),
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  'Download Detailed Report',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // GO TO HOME
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