import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medical_history_controller.dart';

class MedicalHistoryView extends GetView<MedicalHistoryController> {
  const MedicalHistoryView({super.key});

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
          'Step 2 of 6 : Basic Profile',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            const Center(
              child: Text(
                'Medical History',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 15),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 2 / 6,
                minHeight: 8,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 30),

            // ================= CONDITIONS =================
            const Text(
              'Existing Medical Conditions',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...controller.conditions.map(
                    (item) => _chip(
                      label: item,
                      selected: controller.selectedConditions.contains(item),
                      onTap: () => controller.toggleCondition(item),
                    ),
                  ),
                  _chip(
                    label: 'Add Other',
                    isAdd: true,
                    onTap: _showAddOtherCondition,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= ALLERGIES =================
            const Text(
              'Allergies',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Do you have any known allergies?',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...controller.allergies.map(
                    (item) => _chip(
                      label: item,
                      selected: controller.selectedAllergies.contains(item),
                      onTap: () => controller.toggleAllergy(item),
                    ),
                  ),
                  _chip(
                    label: 'Add Other',
                    isAdd: true,
                    onTap: _showAddOtherAllergy,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= PAST PROCEDURES =================
            const Text(
              'Allergies',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Do you have any known allergies?',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 20),

            _textArea(
              controller: controller.pastProceduresController,
              hint: 'List any past procedures or hospital stays...',
            ),

            const SizedBox(height: 30),

            // ================= MEDICATIONS =================
            const Text(
              'Current Medications',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            _singleInput(
              controller: controller.medicationsController,
              hint: 'Name, dosage, and frequency',
            ),

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

  Widget _textArea({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _singleInput({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  void _showAddOtherCondition() {
    _bottomSheet(
      title: 'Add Medical Condition',
      controller: controller.otherConditionController,
      onAdd: controller.addOtherCondition,
    );
  }

  void _showAddOtherAllergy() {
    _bottomSheet(
      title: 'Add Allergy',
      controller: controller.otherAllergyController,
      onAdd: controller.addOtherAllergy,
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
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
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
                      controller.clear();
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
