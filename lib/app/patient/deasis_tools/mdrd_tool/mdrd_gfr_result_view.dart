import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mdrd_gfr_controller.dart';

class MdrdGfrResultView extends GetView<MdrdGfrController> {
  const MdrdGfrResultView({super.key});

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
          'Kidney Function Result',
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
                    // ── Gauge Card ───────────────────────────────
                    _GfrGaugeCard(
                      gfr: controller.gfrResult.value,
                      ckdStageShort: controller.ckdStageShort,
                      riskLevel: controller.riskLevel,
                      gaugeAngle: controller.gaugeAngle,
                    ),

                    const SizedBox(height: 16),

                    // ── Clinical Interpretation Card ─────────────
                    _ClinicalInterpretationCard(
                      ckdStage: controller.ckdStage,
                      medicationDosing: controller.medicationDosing,
                      recommendation: controller.recommendation,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Action Buttons ───────────────────────────────────
            //   _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

// ─── GFR Gauge Card ───────────────────────────────────────────────────────────

class _GfrGaugeCard extends StatelessWidget {
  final double gfr;
  final String ckdStageShort;
  final String riskLevel;
  final double gaugeAngle;

  const _GfrGaugeCard({
    required this.gfr,
    required this.ckdStageShort,
    required this.riskLevel,
    required this.gaugeAngle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // Gauge
          SizedBox(
            height: 140,
            width: 240,
            child: CustomPaint(
              painter: _GfrGaugePainter(needleAngle: gaugeAngle),
            ),
          ),

          const SizedBox(height: 4),

          // Labels
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
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

          // GFR value
          Text(
            '$gfr',
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1,
            ),
          ),
          const Text(
            'ml/min/1.73 m2',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ckdStageShort,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── GFR Gauge Painter ────────────────────────────────────────────────────────

class _GfrGaugePainter extends CustomPainter {
  final double needleAngle; // –1 to +1

  const _GfrGaugePainter({required this.needleAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 10;
    final radius = size.width / 2 - 10;
    const strokeWidth = 18.0;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    paint.shader = SweepGradient(
      startAngle: pi,
      endAngle: 2 * pi,
      colors: const [
        Color(0xFF22C55E), // Low risk (high GFR)
        Color(0xFFEAB308),
        Color(0xFFF97316),
        Color(0xFFEF4444), // High risk (low GFR)
      ],
      stops: const [0.0, 0.4, 0.7, 1.0],
    ).createShader(rect);

    canvas.drawArc(rect, pi, pi, false, paint);

    // Needle
    final angle = pi + ((needleAngle + 1) / 2) * pi;
    final needleLength = radius - 12;
    final x = cx + needleLength * cos(angle);
    final y = cy + needleLength * sin(angle);

    final needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy), Offset(x, y), needlePaint);
    canvas.drawCircle(Offset(cx, cy), 8, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GfrGaugePainter old) =>
      old.needleAngle != needleAngle;
}

// ─── Clinical Interpretation Card ────────────────────────────────────────────

class _ClinicalInterpretationCard extends StatelessWidget {
  final String ckdStage;
  final String medicationDosing;
  final String recommendation;

  const _ClinicalInterpretationCard({
    required this.ckdStage,
    required this.medicationDosing,
    required this.recommendation,
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
            icon: Icons.water_drop_outlined,
            iconBgColor: const Color(0xFFFFE4E4),
            iconColor: const Color(0xFFEF4444),
            label: 'CKD Stage',
            value: ckdStage,
          ),
          const SizedBox(height: 16),
          _InterpretationRow(
            icon: Icons.medication_outlined,
            iconBgColor: const Color(0xFFFFEDD5),
            iconColor: const Color(0xFFF97316),
            label: 'Medication Dosing',
            value: medicationDosing,
          ),
          const SizedBox(height: 16),
          _InterpretationRow(
            icon: Icons.visibility_outlined,
            iconBgColor: const Color(0xFFFFE4E4),
            iconColor: const Color(0xFFEF4444),
            label: 'Recommendation',
            value: recommendation,
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
          // Primary CTA
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
                  'Consult a Nephrologist',
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

          // Secondary CTA
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
                  'Download Detailed Report',
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

          // Go Home
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
