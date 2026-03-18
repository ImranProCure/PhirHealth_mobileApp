import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cancer_risk_area_controller.dart';

// ─────────────────────────────────────────────
// Breakpoint helper
// ─────────────────────────────────────────────
bool _isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= 600;

// ═══════════════════════════════════════════════════════════
//  ROOT VIEW
// ═══════════════════════════════════════════════════════════
class CancerRiskAreaView extends GetView<CancerRiskAreaController> {
  const CancerRiskAreaView({super.key});

  @override
  Widget build(BuildContext context) {
    return _isTablet(context)
        ? _TabletCancerRiskAreaView(controller: controller)
        : _PhoneCancerRiskAreaView(controller: controller);
  }
}

// ═══════════════════════════════════════════════════════════
//  PHONE LAYOUT  (original — untouched)
// ═══════════════════════════════════════════════════════════
class _PhoneCancerRiskAreaView extends StatelessWidget {
  final CancerRiskAreaController controller;
  const _PhoneCancerRiskAreaView({required this.controller});

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
          'Select Risk Area',
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
                children: [
                  _GenderTabs(controller: controller),
                  const SizedBox(height: 20),
                  _AreaGrid(controller: controller, crossAxisCount: 2),
                ],
              ),
            ),
          ),
          _ContinueButton(controller: controller),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TABLET LAYOUT
// ═══════════════════════════════════════════════════════════
class _TabletCancerRiskAreaView extends StatelessWidget {
  final CancerRiskAreaController controller;
  const _TabletCancerRiskAreaView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
          'Select Risk Area',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── LEFT: Info Panel ──────────────────────────────
          Container(
            width: screenWidth * 0.30,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section label
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Step 1 of 3',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select\nRisk Area',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2937),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose the body area you want to screen. Our AI will analyse risk indicators specific to that region.',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),

                // Gender selector — vertical on tablet
                _GenderTabsVertical(controller: controller),

                const Spacer(),

                // Continue button anchored to bottom of left panel
                _ContinueButton(controller: controller),
              ],
            ),
          ),

          // ── RIGHT: Area Grid ──────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _AreaGrid(
                controller: controller,
                crossAxisCount: 3, // 3 cols on tablet
                cardAspectRatio: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════

// ── Horizontal gender tabs (phone) ────────────────────────
class _GenderTabs extends StatelessWidget {
  final CancerRiskAreaController controller;
  const _GenderTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: ['Male', 'Female'].map((g) {
              final bool isSelected = controller.selectedGender.value == g;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectGender(g),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          g == 'Male' ? Icons.male : Icons.female,
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          g,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}

// ── Vertical gender tabs (tablet left panel) ──────────────
class _GenderTabsVertical extends StatelessWidget {
  final CancerRiskAreaController controller;
  const _GenderTabsVertical({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: ['Male', 'Female'].map((g) {
            final bool isSelected = controller.selectedGender.value == g;
            return GestureDetector(
              onTap: () => controller.selectGender(g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      g == 'Male' ? Icons.male : Icons.female,
                      size: 20,
                      color:
                          isSelected ? Colors.white : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      g,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF374151),
                      ),
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 18),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }
}

// ── Area Grid ─────────────────────────────────────────────
class _AreaGrid extends StatelessWidget {
  final CancerRiskAreaController controller;
  final int crossAxisCount;
  final double cardAspectRatio;

  const _AreaGrid({
    required this.controller,
    this.crossAxisCount = 2,
    this.cardAspectRatio = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final areas = controller.currentAreas;
      final selected = controller.selectedArea.value;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: areas.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: cardAspectRatio,
        ),
        itemBuilder: (context, i) =>
            _AreaCard(area: areas[i], selected: selected, controller: controller),
      );
    });
  }
}

// ── Area Card ─────────────────────────────────────────────
class _AreaCard extends StatelessWidget {
  final Map<String, dynamic> area;
  final String selected;
  final CancerRiskAreaController controller;

  const _AreaCard({
    required this.area,
    required this.selected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected == area['label'];
    return GestureDetector(
      onTap: () => controller.selectArea(area['label'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0D9488) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  area['imagePath'] as String,
                  width: 48,
                  height: 48,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.healing_outlined,
                    size: 40,
                    color: Color(0xFF0D9488),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  area['label'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if ((area['sub'] as String).isNotEmpty)
                  Text(
                    area['sub'] as String,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF0D9488)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Continue Button ───────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final CancerRiskAreaController controller;
  const _ContinueButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SizedBox(
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
            onPressed: controller.goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
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
      ),
    );
  }
}