import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_nutritionist_controller.dart';

// ─────────────────────────────────────────────
// Breakpoint helper
// ─────────────────────────────────────────────
bool _isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= 600;

// ═══════════════════════════════════════════════════════════
//  ROOT VIEW
// ═══════════════════════════════════════════════════════════
class AiNutritionistView extends GetView<AiNutritionistController> {
  const AiNutritionistView({super.key});

  @override
  Widget build(BuildContext context) {
    return _isTablet(context)
        ? _TabletAiNutritionistView(controller: controller)
        : _PhoneAiNutritionistView(controller: controller);
  }
}

// ═══════════════════════════════════════════════════════════
//  PHONE LAYOUT
// ═══════════════════════════════════════════════════════════
class _PhoneAiNutritionistView extends StatelessWidget {
  final AiNutritionistController controller;
  const _PhoneAiNutritionistView({required this.controller});

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
          'AI Nutritionist',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle("What's your Goal?"),
                    const SizedBox(height: 12),
                    _GoalGrid(controller: controller),
                    const SizedBox(height: 22),
                    _SectionTitle('Food Preference'),
                    _SectionSub('Select your primary dietary habit'),
                    const SizedBox(height: 12),
                    _FoodRow(controller: controller),
                    const SizedBox(height: 22),
                    _SectionTitle('Activity Level?'),
                    _SectionSub(
                        "We'll adjust your daily caloric intake based on your 4-5 days/week gym schedule."),
                    const SizedBox(height: 14),
                    _ActivitySlider(controller: controller),
                    const SizedBox(height: 22),
                    _SectionTitle('Allergies'),
                    _SectionSub('Do you have any known allergies?'),
                    const SizedBox(height: 12),
                    _AllergiesRow(controller: controller),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: _GenerateButton(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TABLET LAYOUT
// ═══════════════════════════════════════════════════════════
class _TabletAiNutritionistView extends StatelessWidget {
  final AiNutritionistController controller;
  const _TabletAiNutritionistView({required this.controller});

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
          'AI Nutritionist',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.44,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Personalize your plan',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'AI Nutritionist',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2937),
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tell us your goals and preferences to generate a personalised nutrition plan.',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle("What's your Goal?"),
                    const SizedBox(height: 12),
                    _GoalGrid(controller: controller, tablet: true),
                    const SizedBox(height: 24),
                    const _SectionTitle('Food Preference'),
                    _SectionSub('Select your primary dietary habit'),
                    const SizedBox(height: 12),
                    _FoodRow(controller: controller, tablet: true),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _GenerateButton(controller: controller),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Activity Level?'),
                    _SectionSub(
                        "We'll adjust your daily caloric intake based on your activity schedule."),
                    const SizedBox(height: 14),
                    _ActivitySlider(controller: controller),
                    const SizedBox(height: 28),
                    const _SectionTitle('Allergies'),
                    _SectionSub('Do you have any known allergies?'),
                    const SizedBox(height: 12),
                    _AllergiesRow(controller: controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
    );
  }
}

class _SectionSub extends StatelessWidget {
  final String text;
  const _SectionSub(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 13,
          color: Color(0xFF6B7280),
          height: 1.4,
        ),
      ),
    );
  }
}

// ── Goal Grid ─────────────────────────────────────────────
class _GoalGrid extends StatelessWidget {
  final AiNutritionistController controller;
  final bool tablet;
  const _GoalGrid({required this.controller, this.tablet = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: controller.goals.map((g) {
            final bool isSelected = controller.selectedGoal.value == g['label'];
            final bool isFirst = g['label'] == controller.goals.first['label'];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectGoal(g['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: isFirst ? 12 : 0),
                  padding: EdgeInsets.fromLTRB(
                      12, tablet ? 20 : 16, 12, tablet ? 18 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1.5,
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
                        children: [
                          Image.asset(
                            g['imagePath'] as String,
                            height: tablet ? 90 : 80,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.fitness_center,
                              size: tablet ? 70 : 60,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                          SizedBox(height: tablet ? 12 : 10),
                          Text(
                            g['label'] as String,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: tablet ? 16 : 15,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            g['sub'] as String,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
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
                            color: isSelected
                                ? const Color(0xFF0D9488)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 13)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }
}

// ── Food Row ──────────────────────────────────────────────
class _FoodRow extends StatelessWidget {
  final AiNutritionistController controller;
  final bool tablet;
  const _FoodRow({required this.controller, this.tablet = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.foods.map((f) {
            final bool isSelected = controller.selectedFood.value == f['label'];
            return GestureDetector(
              onTap: () => controller.selectFood(f['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: tablet ? 100 : 85,
                height: tablet ? 116 : 104,
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0D9488).withOpacity(0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            f['imagePath'] as String,
                            width: tablet ? 50 : 44,
                            height: tablet ? 50 : 44,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.eco,
                              size: tablet ? 42 : 36,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            f['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: tablet ? 12 : 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 11)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }
}

// ── Activity Slider ───────────────────────────────────────
class _ActivitySlider extends StatelessWidget {
  final AiNutritionistController controller;
  const _ActivitySlider({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  activeTrackColor: const Color(0xFFE5E7EB),
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  thumbColor: const Color(0xFF0D9488),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 11),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                  trackShape: const RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  value: controller.activityLevel.value.toDouble(),
                  min: 0,
                  max: 4,
                  divisions: 4,
                  onChanged: (v) => controller.setActivity(v.round()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  controller.activityLabels.length,
                  (i) => Text(
                    controller.activityLabels[i],
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      fontWeight: controller.activityLevel.value == i
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: controller.activityLevel.value == i
                          ? const Color(0xFF0D9488)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

// ── Allergies Row ─────────────────────────────────────────
class _AllergiesRow extends StatelessWidget {
  final AiNutritionistController controller;
  const _AllergiesRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...controller.allergies.map((a) {
              final bool isSelected = controller.selectedAllergies.contains(a);
              return GestureDetector(
                onTap: () => controller.toggleAllergy(a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isSelected
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFF0D9488), size: 18)
                          : Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFD1D5DB), width: 1.5),
                              ),
                            ),
                      const SizedBox(width: 7),
                      Text(
                        a,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            ...controller.customAllergies.map((a) {
              return GestureDetector(
                onTap: () => controller.removeCustomAllergy(a),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, color: Colors.white, size: 16),
                      const SizedBox(width: 7),
                      Text(
                        a,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            GestureDetector(
              onTap: () => _showAddAllergySheet(controller),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border:
                      Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.black, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Add Other',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _showAddAllergySheet(AiNutritionistController ctrl) {
    final TextEditingController textCtrl = TextEditingController();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Allergy',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: textCtrl,
              autofocus: true,
              style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
              decoration: InputDecoration(
                hintText: 'e.g. Gluten, Lactose...',
                hintStyle: const TextStyle(
                    fontFamily: 'Mulish', color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final val = textCtrl.text.trim();
                    if (val.isNotEmpty) {
                      ctrl.addCustomAllergy(val);
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Add',
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
      ),
      isScrollControlled: true,
    );
  }
}

// ── Generate Button — LOADING STATE ADDED ────────────────
class _GenerateButton extends StatelessWidget {
  final AiNutritionistController controller;
  const _GenerateButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
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
              onPressed:
                  controller.isLoading.value ? null : controller.generatePlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Generate AI Plan',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/wand_stars.png',
                          width: 20,
                          height: 20,
                          color: Colors.white,
                          colorBlendMode: BlendMode.srcIn,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 20),
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
