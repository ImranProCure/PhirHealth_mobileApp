import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/family_wellbeing_controller.dart';

class FamilyWellbeingView extends GetView<FamilyWellbeingController> {
  const FamilyWellbeingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Step 4 of 6 : Lifestyle',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body:SafeArea(
        bottom: true,
        child:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ================= TITLE =================
            const Center(
              child: Text(
                'Family & Well-being',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= PROGRESS =================
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 4 / 6,
                minHeight: 8,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 30),

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
                  children: controller.familyConditions.map((item) {
                    return _chip(
                      label: item,
                      selected:
                          controller.selectedFamilyConditions.contains(item),
                      onTap: () => controller.toggleFamilyCondition(item),
                    );
                  }).toList(),
                )),

            const SizedBox(height: 30),

            // ================= MENTAL WELL-BEING =================
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
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 12),
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
                        Text(
                          'Low',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        Text(
                          'Moderate',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        Text(
                          'High',
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

            Obx(() => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.symptoms.map((item) {
                    return _chip(
                      label: item,
                      selected: controller.selectedSymptoms.contains(item),
                      onTap: () => controller.toggleSymptom(item),
                    );
                  }).toList(),
                )),

            const SizedBox(height: 40),

            // ================= NEXT BUTTON =================
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next Step',
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
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ));
  }

  // ================= REUSABLE CHIP =================
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
}
