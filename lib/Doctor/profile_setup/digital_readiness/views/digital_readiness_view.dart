import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/digital_readiness_controller.dart';

class DigitalReadinessView extends GetView<DigitalReadinessController> {
  const DigitalReadinessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Step 3 of 4',
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

            // ================= TITLE =================
            const Center(
              child: Text(
                'Digital Readiness & Logistics',
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
                value: 3 / 4,
                minHeight: 6,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 30),

            // ================= TECH & PROTOCOLS =================
            const Text(
              'Tech & Protocols',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Experienced in Teleconsultation?',
                        value: controller.teleconsultation.value,
                        onChanged: (val) =>
                            controller.teleconsultation.value = val,
                      ),
                      const SizedBox(height: 24),
                      _toggleRow(
                        title: 'Familiar with EMR Systems?',
                        value: controller.emrSystems.value,
                        onChanged: (val) => controller.emrSystems.value = val,
                      ),
                      const SizedBox(height: 24),
                      _toggleRow(
                        title: 'Willing to follow PHIR clinical protocols?',
                        value: controller.clinicalProtocols.value,
                        onChanged: (val) =>
                            controller.clinicalProtocols.value = val,
                      ),
                      const SizedBox(height: 24),
                      _toggleRow(
                        title: 'Willing to work in multidisciplinary teams?',
                        value: controller.multidisciplinaryTeams.value,
                        onChanged: (val) =>
                            controller.multidisciplinaryTeams.value = val,
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 30),

            // ================= LOGISTICS =================
            const Text(
              'Logistics Sections',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 30),

            // ================= AVAILABILITY =================
            const Text(
              'Availability',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
                controller: controller.availabilityController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Part-time",
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================= LANGUAGE =================
            const Text(
              'Language',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Obx(() => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...controller.languages.map(
                      (item) => _chip(
                        label: item,
                        selected: controller.selectedLanguages.contains(item),
                        onTap: () => controller.toggleLanguage(item),
                      ),
                    ),
                    _addOtherLanguageChip(),
                  ],
                )),

            const SizedBox(height: 30),

            // ================= FEE =================
            const Text(
              'Per Session Fee',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
                controller: controller.feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixText: "₹  ",
                  hintText: "800",
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

  // ================= SWITCH TILE =================
  Widget _toggleRow({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Switch(
          value: value,
          activeColor: const Color(0xFF0D9488),
          onChanged: onChanged,
        ),
      ],
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

  Widget _addOtherLanguageChip() {
    return GestureDetector(
      onTap: controller.openAddLanguageBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 14,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Add Other',
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
    );
  }
}
