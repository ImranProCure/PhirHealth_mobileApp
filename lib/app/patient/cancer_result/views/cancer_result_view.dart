import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cancer_result_controller.dart';

class CancerResultView extends GetView<CancerResultController> {
  const CancerResultView({super.key});

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
        title: const Text(
          'Assessment Result',
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
            onPressed: controller.downloadReport,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== RISK CARD =====
                  _riskCard(),
                  const SizedBox(height: 16),

                  // ===== FINDINGS CARD =====
                  _findingsCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ===== BUTTONS =====
          _buttons(),
        ],
      ),
    );
  }

  // ===== RISK CARD =====
  Widget _riskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
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
          // Gauge
          SizedBox(
            width: 220,
            height: 130,
            child: CustomPaint(
              painter: _GaugePainter(risk: controller.riskLevel),
            ),
          ),
          const SizedBox(height: 4),

          // Low / Moderate / High labels
          SizedBox(
            width: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Low',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: controller.riskLabel == 'Low'
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  'Moderate',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: controller.riskLabel == 'Moderate'
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  'High',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: controller.riskLabel == 'High'
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            controller.riskTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          _richDescription(controller.riskDescription),
        ],
      ),
    );
  }

  Widget _richDescription(String text) {
    // Bold the part in parentheses
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    if (!text.contains('**')) {
      // Check for hemoptysis pattern
      if (text.contains('hemoptysis')) {
        return Text.rich(
          TextSpan(
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Based on your symptoms of '),
              const TextSpan(
                text: 'hemoptysis (coughing blood)',
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
              ),
              const TextSpan(
                  text:
                      ' and clinical history, we recommend immediate medical consultation.'),
            ],
          ),
          textAlign: TextAlign.center,
        );
      }
      return Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          color: Color(0xFF6B7280),
          height: 1.5,
        ),
      );
    }
    return const SizedBox();
  }

  // ===== FINDINGS CARD =====
  Widget _findingsCard() {
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
          const Text(
            'Key Clinical Findings',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(controller.findings.length, (i) {
            final f = controller.findings[i];
            final bool isLast = i == controller.findings.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          f['imagePath'] as String,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.warning_amber_outlined,
                            color: Color(0xFFEF4444),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          f['subtitle'] as String,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!isLast)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ===== BUTTONS =====
  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Consult button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                ),
              ),
              child: ElevatedButton(
                onPressed: controller.consultOncologist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Consult an Oncologist Immediately',
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
          const SizedBox(height: 10),

          // Download button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: controller.downloadReport,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
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
          const SizedBox(height: 10),

          // Go to Home
          GestureDetector(
            onTap: controller.goToHome,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Go to Home',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D9488),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ===== GAUGE PAINTER =====
class _GaugePainter extends CustomPainter {
  final double risk; // 0.0 to 1.0
  const _GaugePainter({required this.risk});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;

    // Background arc
    final bgPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Gradient arc
    final gradPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF22C55E),
          Color(0xFFFBBF24),
          Color(0xFFEF4444),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      gradPaint,
    );

    // Needle
    final needleAngle = math.pi + (risk * math.pi);
    final needleLength = radius - 8;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center dot
    canvas.drawCircle(center, 6, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.risk != risk;
}
