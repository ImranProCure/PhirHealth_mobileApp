import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/experience_controller.dart';

class ExperienceView extends GetView<ExperienceController> {
  const ExperienceView({super.key});

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
          "Step 2 of 4",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// ================= TITLE =================
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

            const SizedBox(height: 15),

            /// ================= PROGRESS =================
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 2 / 4,
                minHeight: 6,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 30),

            /// ================= EXPERIENCE SECTION =================
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
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            /// ================= SLIDER BOX =================
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

            /// ================= PRIMARY SPECIALTY =================
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

            /// ================= PRACTICE DETAILS =================
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

            /// ================= HISTORY =================
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

            _buildNextButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ================= CHIP =================
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

  /// ================= ADD OTHER CHIP =================
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

  /// ================= NEXT BUTTON =================
  Widget _buildNextButton() {
    return SizedBox(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Next Step",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
