import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cancer_risk_area_controller.dart';

class CancerRiskAreaView extends GetView<CancerRiskAreaController> {
  const CancerRiskAreaView({super.key});

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
                  _genderTabs(),
                  const SizedBox(height: 20),
                  _areaGrid(),
                ],
              ),
            ),
          ),
          _continueButton(),
        ],
      ),
    );
  }

  // ===== GENDER TABS =====
  Widget _genderTabs() {
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

  // ===== AREA GRID — single Obx =====
  Widget _areaGrid() {
    return Obx(() {
      final areas = controller.currentAreas;
      final selected = controller.selectedArea.value;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: areas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, i) => _areaCard(areas[i], selected),
      );
    });
  }

  Widget _areaCard(Map<String, dynamic> area, String selected) {
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
            color: isSelected ? const Color(0xFF0D9488) : Colors.transparent,
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
                  color:
                      isSelected ? const Color(0xFF0D9488) : Colors.transparent,
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

  // ===== CONTINUE BUTTON =====
  Widget _continueButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
