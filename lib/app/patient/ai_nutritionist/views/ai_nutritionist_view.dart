import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_nutritionist_controller.dart';

class AiNutritionistView extends GetView<AiNutritionistController> {
  const AiNutritionistView({super.key});

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
                    // ===== GOAL =====
                    _sectionTitle("What's your Goal?"),
                    const SizedBox(height: 12),
                    _goalGrid(),
                    const SizedBox(height: 22),

                    // ===== FOOD PREFERENCE =====
                    _sectionTitle('Food Preference'),
                    _sectionSub('Select your primary dietary habit'),
                    const SizedBox(height: 12),
                    _foodRow(),
                    const SizedBox(height: 22),

                    // ===== ACTIVITY LEVEL =====
                    _sectionTitle('Activity Level?'),
                    _sectionSub(
                        "We'll adjust your daily caloric intake based on your 4-5 days/week gym schedule."),
                    const SizedBox(height: 14),
                    _activitySlider(),
                    const SizedBox(height: 22),

                    // ===== ALLERGIES =====
                    _sectionTitle('Allergies'),
                    _sectionSub('Do you have any known allergies?'),
                    const SizedBox(height: 12),
                    _allergiesRow(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // ===== BUTTON =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                    onPressed: controller.generatePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Row(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HELPERS =====
  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      );

  Widget _sectionSub(String t) => Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          t,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13,
            color: Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
      );

  // ===== GOAL GRID =====
  Widget _goalGrid() {
    return Obx(() => Row(
          children: controller.goals.map((g) {
            final bool isSelected = controller.selectedGoal.value == g['label'];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectGoal(g['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                      right: g['label'] == 'Weight Loss' ? 12 : 0),
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
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
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.fitness_center,
                              size: 60,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            g['label'] as String,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
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
                        child: isSelected
                            ? Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D9488),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 13),
                              )
                            : Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFFD1D5DB),
                                      width: 1.5),
                                ),
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

  // ===== FOOD ROW =====
  Widget _foodRow() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.foods.map((f) {
            final bool isSelected = controller.selectedFood.value == f['label'];
            return GestureDetector(
              onTap: () => controller.selectFood(f['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 85,
                height: 104,
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
                            width: 44,
                            height: 44,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.eco,
                              size: 36,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            f['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 11,
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
                      child: isSelected
                          ? Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D9488),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 11),
                            )
                          : Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFD1D5DB), width: 1.5),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  // ===== ACTIVITY SLIDER =====
  Widget _activitySlider() {
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

  // ===== ALLERGIES =====
  Widget _allergiesRow() {
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

            // Custom allergies added by user
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

            // Add Other
            GestureDetector(
              onTap: () => _showAddAllergySheet(),
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

  void _showAddAllergySheet() {
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
                      controller.addCustomAllergy(val);
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
