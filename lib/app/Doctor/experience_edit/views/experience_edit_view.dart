import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/experience_edit_controller.dart';

class ExperienceEditView extends GetView<ExperienceEditController> {
  const ExperienceEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Edit Experience",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeleton();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Experience & Expertise",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Experience Section",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Total Experience",
                style: TextStyle(fontFamily: 'Mulish', fontSize: 14),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            enabledThumbRadius: 12,
                          ),
                        ),
                        child: Slider(
                          value: controller.totalExperience.value,
                          min: 0,
                          max: 40,
                          divisions: 40,
                          onChanged: (value) {
                            controller.totalExperience.value = value;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "0 yrs",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          Text(
                            "${controller.totalExperience.value.toInt()} Years",
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const Text(
                            "40+ yrs",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 30),
              const Text(
                "Primary Specialty",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: controller.specialtyController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter specialty",
                    hintStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 30),
              const Text(
                "Practice Details",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Current Practice Place",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: controller.practicePlaces
                        .map((item) => _chip(
                              label: item,
                              selected: controller.selectedPracticePlaces
                                  .contains(item),
                              onTap: () => controller.togglePracticePlace(item),
                            ))
                        .toList(),
                  )),
              const SizedBox(height: 30),
              const Text(
                "Care Experience",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...controller.careExperiences.map(
                        (item) => _chip(
                          label: item,
                          selected:
                              controller.selectedCareExperience.contains(item),
                          onTap: () => controller.toggleCareExperience(item),
                        ),
                      ),
                      _addOtherChip(),
                    ],
                  )),
              const SizedBox(height: 30),
              const Text(
                "Gynecological History",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: controller.historyController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        "Briefly describe your experience\nwith OPD / Emergency care...",
                    hintStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              _buildUpdateButton(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  // ===== SKELETON =====
  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            Center(child: _sBox(width: 200, height: 22, radius: 8)),
            const SizedBox(height: 30),

            // Section heading
            _sBox(width: 160, height: 18, radius: 6),
            const SizedBox(height: 20),
            _sBox(width: 120, height: 14, radius: 6),
            const SizedBox(height: 20),

            // Slider box
            _sBox(width: double.infinity, height: 100, radius: 20),
            const SizedBox(height: 30),

            // Specialty
            _sBox(width: 130, height: 14, radius: 6),
            const SizedBox(height: 10),
            _sBox(width: double.infinity, height: 56, radius: 12),
            const SizedBox(height: 40),

            const Divider(),
            const SizedBox(height: 30),

            // Practice Details
            _sBox(width: 140, height: 18, radius: 6),
            const SizedBox(height: 30),
            _sBox(width: 170, height: 14, radius: 6),
            const SizedBox(height: 20),

            // Chips row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                3,
                (_) => _sBox(width: 100, height: 40, radius: 24),
              ),
            ),

            const SizedBox(height: 30),

            _sBox(width: 130, height: 14, radius: 6),
            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                4,
                (_) => _sBox(width: 90, height: 40, radius: 24),
              ),
            ),

            const SizedBox(height: 30),

            // History
            _sBox(width: 160, height: 14, radius: 6),
            const SizedBox(height: 20),
            _sBox(width: double.infinity, height: 120, radius: 12),

            const SizedBox(height: 50),

            // Button
            _sBox(width: double.infinity, height: 56, radius: 28),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6F5F3) : Colors.white,
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
              color: const Color(0xFF0D9488),
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

  Widget _addOtherChip() {
    return GestureDetector(
      onTap: controller.openAddOtherBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF111827)),
            SizedBox(width: 8),
            Text(
              "Add Other",
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(
      () => SizedBox(
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
            onPressed: controller.isSubmitting.value
                ? null
                : controller.updateExperience,
            child: controller.isSubmitting.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Update",
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
    );
  }
}
