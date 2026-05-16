import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_controller.dart';

class AscvdInfoView extends GetView<AscvdController> {
  const AscvdInfoView({super.key});

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
          'ASCVD Risk Estimator',
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heart banner image placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A1628),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // ECG line decoration
                          Image.asset("assets/Mask group_hh.png"),
                          // Heart icon
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.cyan.withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 70,
                              color: Color(0xFF00BCD4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'ASCVD (Atherosclerotic Cardiovascular Disease) 2013 Risk Calculator from AHA/ACC',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  const Text(
                    'Determine 10-year risk of hard ASCVD, i.e. myocardial infarction, stroke, or death due to coronary heart disease or stroke.',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Important card
                  _InfoCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Important',
                    titleColor: const Color(0xFFF59E0B),
                    bullets: const [
                      'This calculator includes inputs based on race, which may or may not provide better estimates, so we have decided to make race optional.',
                      'This tool often estimates higher risk for Black/African American adults than for other groups with the same profile, but this is not universal.',
                      'Looking for a race-free equation to calculate CVD risk? Check out the new PREVENT score.',
                    ],
                    highlightIndices: const [2],
                  ),
                  const SizedBox(height: 14),

                  // Instructions card
                  _InfoCard(
                    icon: Icons.menu_book_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Instructions',
                    titleColor: const Color(0xFF10B981),
                    bullets: const [
                      'Our ASCVD Risk Algorithm is a step-wise approach for all adult patients – including those with known ASCVD.',
                      'This calculator is for use only in adult patients without known ASCVD and LDL 70-189 mg/dL (1.81-4.90 mmol/L).'
                    ],
                    isCollapsed: true,
                  ),
                ],
              ),
            ),
          ),

          // Continue button
          _ContinueButton(onTap: controller.onContinueFromInfo),
        ],
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final List<String> bullets;
  final List<int> highlightIndices;
  final bool isCollapsed;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.bullets,
    this.highlightIndices = const [],
    this.isCollapsed = false,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = !widget.isCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(widget.icon, color: widget.iconColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: widget.titleColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),

          // Expanded bullets
          if (_expanded && widget.bullets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: List.generate(widget.bullets.length, (i) {
                  final isHighlight = widget.highlightIndices.contains(i);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF6B7280))),
                        Expanded(
                          child: isHighlight
                              ? RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      color: Color(0xFF374151),
                                      height: 1.5,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text:
                                              'Looking for a race-free equation to calculate CVD risk? Check out the new '),
                                      TextSpan(
                                        text: 'PREVENT',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const TextSpan(text: ' score.'),
                                    ],
                                  ),
                                )
                              : Text(
                                  widget.bullets[i],
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    color: Color(0xFF374151),
                                    height: 1.5,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Continue Button ──────────────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ContinueButton({required this.onTap});

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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── ECG Painter ─────────────────────────────────────────────────────────────

class _EcgLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00BCD4).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    double x = 0;
    double midY = size.height / 2;

    path.moveTo(x, midY);
    x += 30;
    path.lineTo(x, midY);
    x += 10;
    path.lineTo(x, midY - 15);
    x += 5;
    path.lineTo(x, midY + 10);
    x += 5;
    path.lineTo(x, midY - 40);
    x += 5;
    path.lineTo(x, midY + 20);
    x += 5;
    path.lineTo(x, midY);
    x += 10;
    path.lineTo(x, midY - 8);
    x += 10;
    path.lineTo(x, midY);

    // repeat
    path.lineTo(size.width, midY);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
