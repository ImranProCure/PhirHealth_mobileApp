import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lifestyle_edit_controller.dart';

class LifestyleEditView extends GetView<LifestyleEditController> {
  const LifestyleEditView({super.key});

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
          'Habits & Lifestyle',
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
                const SizedBox(height: 14),

                // ================= SMOKING =================
                const Text('Smoking',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const Text('What is your current smoking status?',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Obx(() => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: controller.smokingOptions.map((item) {
                        return _chip(
                          label: item,
                          selected: controller.selectedSmoking.value == item,
                          onTap: () => controller.selectSmoking(item),
                        );
                      }).toList(),
                    )),

                const SizedBox(height: 30),

                // ================= ALCOHOL =================
                const Text('Alcohol',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const Text('How often do you consume alcohol?',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Obx(() => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: controller.alcoholOptions.map((item) {
                        return _chip(
                          label: item,
                          selected: controller.selectedAlcohol.value == item,
                          onTap: () => controller.selectAlcohol(item),
                        );
                      }).toList(),
                    )),

                const SizedBox(height: 30),

                // ================= DIET =================
                const Text('Diet preference',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const Text('Select your primary dietary habit',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 25),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _dietCard(
                          label: 'Vegetarian',
                          icon: 'assets/icons/broccoli 1.png',
                          selected:
                              controller.selectedDiet.value == 'Vegetarian',
                          onTap: () => controller.selectDiet('Vegetarian'),
                        ),
                        _dietCard(
                          label: 'Non-Veg',
                          icon: 'assets/icons/chicken-leg 1.png',
                          selected: controller.selectedDiet.value == 'Non-Veg',
                          onTap: () => controller.selectDiet('Non-Veg'),
                        ),
                        _dietCard(
                          label: 'Vegan',
                          icon: 'assets/icons/salad (1) 1.png',
                          selected: controller.selectedDiet.value == 'Vegan',
                          onTap: () => controller.selectDiet('Vegan'),
                        ),
                        _dietCard(
                          label: 'Eggitarian',
                          icon: 'assets/icons/eggs 1.png',
                          selected:
                              controller.selectedDiet.value == 'Eggitarian',
                          onTap: () => controller.selectDiet('Eggitarian'),
                        ),
                      ],
                    )),

                const SizedBox(height: 30),

                // ================= SLEEP =================
                const Text('Average Sleep',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const Text('How many hours do you sleep per night?',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Obx(() {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF0D9488),
                            inactiveTrackColor: const Color(0xFFD1D5DB),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 14),
                            thumbColor: const Color(0xFF0D9488),
                            overlayColor: const Color(0x330D9488),
                          ),
                          child: Slider(
                            value: controller.sleepIndex.value.toDouble(),
                            min: 0,
                            max: 2,
                            divisions: 2,
                            onChanged: (value) {
                              controller.sleepIndex.value = value.toInt();
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _sleepLabel('2 hrs', 0),
                            _sleepLabel('6-8 hrs', 1),
                            _sleepLabel('8+ hrs', 2),
                          ],
                        ),
                      ],
                    ),
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

  // ================= CHIP =================
  Widget _chip({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color:
                  selected ? const Color(0xFF0D9488) : const Color(0xFF9CA3AF),
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

  // ================= SKELETON =================
  Widget _buildSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),

          // Smoking
          _skBox(width: 80, height: 16),
          const SizedBox(height: 10),
          _skBox(width: 220, height: 14),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
                3, (_) => _skBox(width: 90, height: 40, radius: 24)),
          ),

          const SizedBox(height: 30),

          // Alcohol
          _skBox(width: 80, height: 16),
          const SizedBox(height: 10),
          _skBox(width: 240, height: 14),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
                3, (_) => _skBox(width: 100, height: 40, radius: 24)),
          ),

          const SizedBox(height: 30),

          // Diet
          _skBox(width: 120, height: 16),
          const SizedBox(height: 10),
          _skBox(width: 200, height: 14),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (_) => _skBox(width: 78, height: 104, radius: 20),
            ),
          ),

          const SizedBox(height: 30),

          // Sleep
          _skBox(width: 120, height: 16),
          const SizedBox(height: 10),
          _skBox(width: 230, height: 14),
          const SizedBox(height: 20),
          _skBox(width: double.infinity, height: 110, radius: 24),

          const SizedBox(height: 40),

          // Button
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

  // ================= DIET CARD =================
  Widget _dietCard({
    required String label,
    required String icon,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Image.asset(icon),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sleepLabel(String label, int index) {
    return Obx(() {
      final isSelected = controller.sleepIndex.value == index;

      return Text(
        label,
        style: TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? const Color(0xFF0D9488) : const Color(0xFF6B7280),
        ),
      );
    });
  }
}

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
