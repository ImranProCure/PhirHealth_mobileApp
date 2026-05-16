import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_controller.dart';

class AscvdResultView extends GetView<AscvdController> {
  const AscvdResultView({super.key});

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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '10-Year ASCVD Risk',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.share_outlined,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {},
          // ),
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
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // RISK CARD

                    _RiskGaugeCard(
                      riskLevel:
                          controller.riskLevel,
                      tenYearRisk: controller
                          .tenYearRisk.value,
                      optimalRisk: controller
                          .optimalRisk.value,
                      statinRecommended:
                          controller
                              .statinRecommended
                              .value,
                      gaugeAngle:
                          controller.gaugeAngle,
                    ),

                    const SizedBox(
                        height: 16),

                    // DETAILS CARD

                    _HeartScoreDetailsCard(
                      riskLevel:
                          controller.riskLevel,
                      tenYearRisk: controller
                          .tenYearRisk.value,
                      optimalRisk: controller
                          .optimalRisk.value,
                      statinRecommended:
                          controller
                              .statinRecommended
                              .value,
                    ),

                    const SizedBox(
                        height: 16),

                    // DISCLAIMER

                    Container(
                      padding:
                          const EdgeInsets.all(
                              14),
                      decoration:
                          BoxDecoration(
                        color: const Color(
                            0xFFFFFBEB),
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Color(
                                0xFFD97706),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This calculator provides an estimate and should not replace professional medical advice.',
                              style:
                                  TextStyle(
                                fontFamily:
                                    'Mulish',
                                fontSize:
                                    12,
                                height:
                                    1.5,
                                color: Color(
                                    0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BUTTONS

            //const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RISK CARD
// ─────────────────────────────────────────────────────────────

class _RiskGaugeCard extends StatelessWidget {
  final String riskLevel;
  final double tenYearRisk;
  final double optimalRisk;
  final bool statinRecommended;
  final double gaugeAngle;

  const _RiskGaugeCard({
    required this.riskLevel,
    required this.tenYearRisk,
    required this.optimalRisk,
    required this.statinRecommended,
    required this.gaugeAngle,
  });

  Color get riskColor {
    if (tenYearRisk < 5) {
      return const Color(0xFF22C55E);
    }

    if (tenYearRisk < 7.5) {
      return const Color(0xFFEAB308);
    }

    if (tenYearRisk < 20) {
      return const Color(0xFFF97316);
    }

    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
                    0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // GAUGE

          SizedBox(
            height: 140,
            width: 240,
            child: CustomPaint(
              painter: _GaugePainter(
                needleAngle:
                    gaugeAngle,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // LABELS

          const Padding(
            padding:
                EdgeInsets.symmetric(
                    horizontal: 8),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text(
                  'Low',
                  style: TextStyle(
                    fontFamily:
                        'Mulish',
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                    color: Color(
                        0xFF22C55E),
                  ),
                ),
                Text(
                  'Intermediate',
                  style: TextStyle(
                    fontFamily:
                        'Mulish',
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Colors.black,
                  ),
                ),
                Text(
                  'High',
                  style: TextStyle(
                    fontFamily:
                        'Mulish',
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                    color: Color(
                        0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TITLE

          Text(
            '$riskLevel Risk',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 22,
              fontWeight:
                  FontWeight.w800,
              color: riskColor,
            ),
          ),

          const SizedBox(height: 12),

          // DESCRIPTION

          Text(
            'Your estimated 10-year risk of atherosclerotic cardiovascular disease (ASCVD) is $tenYearRisk%. An optimal risk for someone with ideal risk factors is approximately $optimalRisk%. ${statinRecommended ? 'Guideline-based statin therapy discussion may be considered.' : 'Lifestyle optimization is currently the primary recommendation.'}',
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              height: 1.7,
              color:
                  Color(0xFF6B7280),
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

class _GaugePainter
    extends CustomPainter {
  final double needleAngle;

  const _GaugePainter({
    required this.needleAngle,
  });

  @override
  void paint(
      Canvas canvas,
      Size size) {
    final cx = size.width / 2;

    final cy =
        size.height - 10;

    final radius =
        size.width / 2 - 10;

    const strokeWidth = 18.0;

    final rect = Rect.fromCircle(
      center: Offset(cx, cy),
      radius: radius,
    );

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round;

    paint.shader =
        SweepGradient(
      startAngle: pi,
      endAngle: 2 * pi,
      colors: const [
        Color(0xFF22C55E),
        Color(0xFFEAB308),
        Color(0xFFF97316),
        Color(0xFFEF4444),
      ],
      stops: const [
        0.0,
        0.4,
        0.7,
        1.0,
      ],
    ).createShader(rect);

    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      paint,
    );

    // NEEDLE

    final angle =
        pi +
            ((needleAngle + 1) /
                    2) *
                pi;

    final needleLength =
        radius - 12;

    final x = cx +
        needleLength *
            cos(angle);

    final y = cy +
        needleLength *
            sin(angle);

    final needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap =
          StrokeCap.round;

    canvas.drawLine(
      Offset(cx, cy),
      Offset(x, y),
      needlePaint,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      8,
      Paint()
        ..color = Colors.black,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      4,
      Paint()
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(
      covariant _GaugePainter old) {
    return old.needleAngle !=
        needleAngle;
  }
}

// ─────────────────────────────────────────────────────────────
// DETAILS CARD
// ─────────────────────────────────────────────────────────────

class _HeartScoreDetailsCard
    extends StatelessWidget {
  final String riskLevel;
  final double tenYearRisk;
  final double optimalRisk;
  final bool statinRecommended;

  const _HeartScoreDetailsCard({
    required this.riskLevel,
    required this.tenYearRisk,
    required this.optimalRisk,
    required this.statinRecommended,
  });

  Color get riskColor {
    if (tenYearRisk < 5) {
      return const Color(0xFF22C55E);
    }

    if (tenYearRisk < 7.5) {
      return const Color(0xFFEAB308);
    }

    if (tenYearRisk < 20) {
      return const Color(0xFFF97316);
    }

    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
                    0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Risk Summary',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 18),

          _ScoreRow(
            icon:
                Icons.warning_rounded,
            iconColor: riskColor,
            label:
                'Current 10-Year Risk',
            value:
                '$tenYearRisk% ($riskLevel)',
          ),

          const SizedBox(height: 16),

          _ScoreRow(
            icon: Icons
                .monitor_heart_outlined,
            iconColor:
                const Color(
                    0xFF2563EB),
            label:
                'Optimal Risk Target',
            value:
                '$optimalRisk%',
          ),

          const SizedBox(height: 16),

          _ScoreRow(
            icon: Icons.history,
            iconColor:
                const Color(
                    0xFF0D9488),
            label:
                'Statin Therapy',
            value:
                statinRecommended
                    ? 'Consider Discussion'
                    : 'Lifestyle Focus',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SCORE ROW
// ─────────────────────────────────────────────────────────────

class _ScoreRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _ScoreRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:
                iconColor.withOpacity(
                    0.12),
            borderRadius:
                BorderRadius
                    .circular(14),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(
                  fontFamily:
                      'Mulish',
                  fontSize: 14,
                  fontWeight:
                      FontWeight
                          .w700,
                  color:
                      Colors.black,
                ),
              ),

              const SizedBox(
                  height: 2),

              Text(
                value,
                style:
                    const TextStyle(
                  fontFamily:
                      'Mulish',
                  fontSize: 13,
                  color: Color(
                      0xFF6B7280),
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
// ACTION BUTTONS
// ─────────────────────────────────────────────────────────────

class _ActionButtons
    extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
              16, 8, 16, 32),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 56,
              width:
                  double.infinity,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius
                        .circular(
                            32),
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(
                        0xFF0D9488),
                    Color(
                        0xFF2563EB),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'View Risk Reduction Tips',
                  style:
                      TextStyle(
                    fontFamily:
                        'Mulish',
                    fontSize: 16,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: Colors
                        .white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: () {},
            child: Container(
              height: 56,
              width:
                  double.infinity,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius
                        .circular(
                            32),
                border: Border.all(
                  color: const Color(
                      0xFF0D9488),
                  width: 1.5,
                ),
                color:
                    Colors.white,
              ),
              child: const Center(
                child: Text(
                  'Download ASCVD Report',
                  style:
                      TextStyle(
                    fontFamily:
                        'Mulish',
                    fontSize: 16,
                    fontWeight:
                        FontWeight
                            .w700,
                    color: Color(
                        0xFF0D9488),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => Get.until(
              (route) =>
                  route.isFirst,
            ),
            child: const Text(
              'Go to Home',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF0D9488),
              ),
            ),
          ),
        ],
      ),
    );
  }
}