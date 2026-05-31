import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mdrd_gfr_controller.dart';

class MdrdGfrInfoView extends GetView<MdrdGfrController> {
  const MdrdGfrInfoView({super.key});

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
          'MDRD GFR Equation calculator',
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
                  // ── Banner ──────────────────────────────────────
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
                          // Background glow
                          Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF0D9488).withOpacity(0.25),
                                  Colors.transparent,
                                ],
                                radius: 0.8,
                              ),
                            ),
                          ),
                          // Kidney icon + health score badge
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF0D9488)
                                          .withOpacity(0.15),
                                      border: Border.all(
                                        color: const Color(0xFF0D9488)
                                            .withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.water_drop_outlined,
                                      size: 48,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ),
                                  // Health Score Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D9488),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Health Score',
                                          style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 8,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          '92%',
                                          style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Title ────────────────────────────────────────
                  const Text(
                    'MDRD GFR Equation',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Estimates GFR in CKD patients using creatinine and patient characteristics.',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Important Card ───────────────────────────────
                  _InfoCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Important',
                    titleColor: const Color(0xFFF59E0B),
                    bullets: const [
                      'This calculator includes inputs based on race, which may or may not provide better estimates, so we have decided to make race optional. See here for more on our approach to addressing race and bias on MDCalc.',
                      'For the same creatinine value, this calculator estimates a higher GFR for Black patients.',
                    ],
                    isCollapsed: false,
                  ),

                  const SizedBox(height: 14),

                  // ── Instructions Card ────────────────────────────
                  _InfoCard(
                    icon: Icons.menu_book_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Instructions',
                    titleColor: const Color(0xFF10B981),
                    bullets: const [
                      'The MDRD equation is used to estimate GFR in adults with chronic kidney disease (CKD).',
                      'Requires age, sex, race, and serum creatinine (µmol/L). Results are most reliable for GFR < 60 mL/min/1.73m².',
                    ],
                    isCollapsed: true,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Continue Button ──────────────────────────────────────
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
  final bool isCollapsed;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.bullets,
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
          if (_expanded && widget.bullets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: List.generate(widget.bullets.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF6B7280))),
                        Expanded(
                          child: Text(
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
