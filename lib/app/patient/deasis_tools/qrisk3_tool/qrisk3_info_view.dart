import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_tool/ascvd_controller.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_controller.dart';

class Qrisk3InfoView extends GetView<Qrisk3Controller> {
  const Qrisk3InfoView({super.key});

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
          'QRISK®3  risk calculator',
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
                    'Welcome to the QRISK®3 risk calculator',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _InfoCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Important',
                    titleColor: const Color(0xFFF59E0B),
                    bullets: const [
                      'This demonstrator is intended for reference purposes only, and as a guide.',
                      'Note that this calculator is not intended for clinical use.',
                      'Professionals intending to use thus calculator should ensure they are using a clinical management system that has been accredited in their country for this purpose.',
                      'This site uses the QRISK3 calculator to present and an approximation of a persons risk of developing a heart attack or stroke over the next 10 years, ( assuming they do not already have cardiovascular disease and are not on statins) . A score is produced as described in this academic paper:',
                      'Development and validation of QRISK3 risk prediction algorithms to estimate future risk of cardiovascular disease: prospective cohort study, BMJ 2017;357:j2099',
                    ],
                    highlightIndices: const [2],
                  ),
                  const SizedBox(height: 14),
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
