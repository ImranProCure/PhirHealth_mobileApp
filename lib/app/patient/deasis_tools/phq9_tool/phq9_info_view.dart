import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'phq9_controller.dart';

class Phq9InfoView extends GetView<Phq9Controller> {
  const Phq9InfoView({super.key});

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
          'PHQ-9',
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
                        color: Color(0xFFEEF2FF),
                      ),
                      child: Stack(
                        children: [
                          // Decorative circles
                          Positioned(
                            right: -30,
                            top: -30,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF818CF8).withOpacity(0.15),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            bottom: -20,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF34D399).withOpacity(0.15),
                              ),
                            ),
                          ),
                          // Brain / mental-health icon + score badge
                          Center(
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF6366F1).withOpacity(0.12),
                                    border: Border.all(
                                      color: const Color(0xFF6366F1).withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.psychology_outlined,
                                    size: 48,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                                // Anxiety Check badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6366F1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Anxiety Check',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 7,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        '18',
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'PHQ-9 (Patient Health\nQuestionnaire-9)',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Objectifies degree of depression severity.',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Important Card
                  _InfoCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Important',
                    titleColor: const Color(0xFFF59E0B),
                    bullets: const [
                      'MDCalc provides tools and content intended for use by healthcare professionals, and is not meant for use by patients. While these may be surveys or questions intended for patients, they are meant to be answered in the context of a clinician\'s medical care and not on their own to diagnose or treat any disease.',
                    ],
                    isCollapsed: false,
                  ),

                  const SizedBox(height: 20),

                  // // Score legend tile
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(16),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.04),
                  //         blurRadius: 10,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     children: const [
                  //       _ScoreLegendRow(label: 'Not at all', score: '0'),
                  //       _Divider(),
                  //       _ScoreLegendRow(label: 'Several days', score: '+1'),
                  //       _Divider(),
                  //       _ScoreLegendRow(label: 'More than half the days', score: '+2'),
                  //       _Divider(),
                  //       _ScoreLegendRow(label: 'Nearly every day', score: '+3'),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Continue Button
          _ContinueButton(onTap: controller.onContinueFromInfo),
        ],
      ),
    );
  }
}

// ─── Score Legend Row ─────────────────────────────────────────────────────────

class _ScoreLegendRow extends StatelessWidget {
  final String label;
  final String score;
  const _ScoreLegendRow({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6));
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
                    padding: const EdgeInsets.only(bottom: 8),
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
