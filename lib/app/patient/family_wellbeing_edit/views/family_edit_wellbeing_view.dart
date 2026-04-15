import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/family_wellbeing_edit_controller.dart';

class FamilyWellbeingEditView extends GetView<FamilyWellbeingEditController> {
  const FamilyWellbeingEditView({super.key});

  // ================= SKELETON =================
  Widget _buildSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _skBox(width: 200, height: 16),
          const SizedBox(height: 10),
          _skBox(width: 280, height: 14),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
                4, (_) => _skBox(width: 110, height: 40, radius: 24)),
          ),
          const SizedBox(height: 30),
          _skBox(width: 150, height: 16),
          const SizedBox(height: 10),
          _skBox(width: 260, height: 14),
          const SizedBox(height: 20),
          _skBox(width: double.infinity, height: 110, radius: 20),
          const SizedBox(height: 30),
          _skBox(width: 160, height: 16),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
                4, (_) => _skBox(width: 100, height: 40, radius: 24)),
          ),
          const SizedBox(height: 40),
          _skBox(width: double.infinity, height: 56, radius: 28),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _skBox({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Family & Well-being',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        child: Obx(() {
          if (controller.isLoading.value) {
            return _ShimmerWrapper(child: _buildSkeleton());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ================= FAMILY MEDICAL HISTORY =================
                const Text(
                  'Family Medical History',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Have your immediate family members had any of these?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Obx(() => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        // existing family condition chips
                        ...controller.familyConditions.map(
                          (item) => _chip(
                            label: item,
                            selected: controller.selectedFamilyConditions
                                .contains(item),
                            onTap: () => controller.toggleFamilyCondition(item),
                          ),
                        ),
                        // ---- Add Other chip ----
                        _chip(
                          label: 'Add Other',
                          isAdd: true,
                          onTap: _showAddOtherFamilyCondition,
                        ),
                      ],
                    )),

                const SizedBox(height: 30),

                // ================= MENTAL WELL-BEING =================
                const Text(
                  'Mental Well-being',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'How would you rate your current stress levels?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF0D9488),
                            inactiveTrackColor: const Color(0xFFE5E7EB),
                            thumbColor: const Color(0xFF0D9488),
                            overlayColor: const Color(0x330D9488),
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12),
                          ),
                          child: Slider(
                            value: controller.stressIndex.value.toDouble(),
                            min: 0,
                            max: 2,
                            divisions: 2,
                            onChanged: (value) {
                              controller.stressIndex.value = value.toInt();
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Low',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9CA3AF))),
                            Text('Moderate',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9CA3AF))),
                            Text('High',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // ================= COMMON SYMPTOMS =================
                // ================= COMMON SYMPTOMS =================
                const Text(
                  'Common Symptoms',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isSymptomsLoading.value) {
                    return _ShimmerWrapper(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(4,
                            (_) => _skBox(width: 100, height: 40, radius: 24)),
                      ),
                    );
                  }
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...controller.symptoms.map((item) => _chip(
                            label: item,
                            selected:
                                controller.selectedSymptoms.contains(item),
                            onTap: () => controller.toggleSymptom(item),
                          )),
                      // ← NEW: "Add Other" chip, same as family conditions
                      _chip(
                        label: 'Add Other',
                        isAdd: true,
                        onTap: _showAddOtherSymptom,
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 40),

                // ================= BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00786F),
                          Color(0xFF009689),
                          Color(0xFF1447E6),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: controller.goToNextStep,
                      child: const Text(
                        'Update',
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

                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showAddOtherSymptom() {
    _bottomSheet(
      title: 'Add Symptom',
      controller: controller.otherSymptomController,
      onAdd: controller.addOtherSymptom,
    );
  }

  // ================= CHIP =================
  Widget _chip({
    required String label,
    bool selected = false,
    bool isAdd = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdd)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              )
            else
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color: selected
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF9CA3AF),
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF0D9488) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SHOW BOTTOM SHEET =================
  void _showAddOtherFamilyCondition() {
    _bottomSheet(
      title: 'Add Family Condition',
      controller: controller.otherFamilyConditionController,
      onAdd: controller.addOtherFamilyCondition,
    );
  }

  void _bottomSheet({
    required String title,
    required TextEditingController controller,
    required VoidCallback onAdd,
  }) {
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter here...',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF00786F),
                        Color(0xFF009689),
                        Color(0xFF1447E6),
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) {
                        Get.snackbar(
                          'Required',
                          'Please enter a value',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      onAdd();
                      Get.back();
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
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
      ),
      isScrollControlled: true,
    );
  }
}

// ================= SHIMMER =================
class _ShimmerWrapper extends StatefulWidget {
  final Widget child;
  const _ShimmerWrapper({required this.child});

  @override
  State<_ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<_ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFFFFFFF),
                Color(0xFFEEEEEE),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
