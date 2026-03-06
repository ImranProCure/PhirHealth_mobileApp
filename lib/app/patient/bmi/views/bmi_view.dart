import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/bmi_controller.dart';

class BmiView extends GetView<BmiController> {
  const BmiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D7377), Color(0xFF0D5C8A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== APP BAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Text(
                        'BMI Calculator',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check your body mass index instantly',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ===== GENDER =====
                      _genderSelector(),
                      const SizedBox(height: 24),

                      // ===== AGE =====
                      _fieldLabel('Age'),
                      const SizedBox(height: 8),
                      _inputRow(
                        imagePath: 'assets/icons/Group 189.png',
                        controller: TextEditingController(
                            text: controller.age.value.toString()),
                        unit: 'yrs',
                        onChanged: controller.onAgeChanged,
                        displayText: () => '${controller.age.value} Years',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),

                      // ===== HEIGHT =====
                      _fieldLabel('Height'),
                      const SizedBox(height: 8),
                      _inputRow(
                        imagePath: 'assets/icons/Frame 21.png',
                        controller: TextEditingController(
                            text: controller.height.value),
                        unit: 'ft',
                        onChanged: controller.onHeightChanged,
                        displayText: () => '${controller.height.value} ft',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),

                      // ===== WEIGHT =====
                      _fieldLabel('Weight'),
                      const SizedBox(height: 8),
                      _inputRow(
                        imagePath: 'assets/icons/Group 189-1.png',
                        controller: TextEditingController(
                            text: controller.weight.value.toString()),
                        unit: 'kg',
                        onChanged: controller.onWeightChanged,
                        displayText: () => '${controller.weight.value} kg',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ Color(0xFF0D5C8A), Color(0xFF0D5C8A)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: controller.calculateBmi,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              'Calculate BMI',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D7377),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderSelector() {
    return Obx(() => Row(
          children: controller.genders.map((g) {
            final bool isSelected =
                controller.selectedGender.value == g['label'];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectGender(g['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      EdgeInsets.only(right: g['label'] != 'Other' ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0D9488), Color(0xFF1565C0)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFF0D5C6E),
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: Colors.white30, width: 1)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(g['icon'] as IconData,
                          color: Colors.white, size: 35),
                      const SizedBox(height: 6),
                      Text(
                        g['label'] as String,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _inputRow({
    required String imagePath,
    required TextEditingController controller,
    required String unit,
    required Function(String) onChanged,
    required String Function() displayText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D5C6E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Image icon
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
            color: Colors.white70,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.info_outline, color: Colors.white70, size: 28),
          ),
          const SizedBox(width: 12),

          // Input box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A4A5C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    inputFormatters: keyboardType == TextInputType.number
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [],
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Text(
                  '  $unit',
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Live display
          Obx(() => Text(
                displayText(),
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
