import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coach_step2_controller.dart';

class CoachStep2View extends GetView<CoachStep2Controller> {
  const CoachStep2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
        ),
        title: const Text('Step 2 of 6',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('Qualifications',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(2, 6),
                  const SizedBox(height: 24),

                  // Partnership Type Section
                  const Text('Partnership Type',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 16),

                  _buildLabel('Highest Qualification'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: controller.qualificationController,
                      hint: 'e.g. Master of Psychology'),
                  const SizedBox(height: 20),

                  _buildLabel('University/Institution'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: controller.universityController,
                      hint: 'e.g. Stanford University'),
                  const SizedBox(height: 20),

                  // Field of Study + Year — side by side
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Field of Study'),
                            const SizedBox(height: 8),
                            Obx(() => _buildDropdown(
                                  value: controller.selectedField.value.isEmpty
                                      ? 'Select field'
                                      : controller.selectedField.value,
                                  isEmpty:
                                      controller.selectedField.value.isEmpty,
                                  onTap: () =>
                                      controller.showFieldSheet(context),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Year of Graduation'),
                            const SizedBox(height: 8),
                            Obx(() => _buildDropdown(
                                  value: controller.selectedYear.value.isEmpty
                                      ? 'YYYY'
                                      : controller.selectedYear.value,
                                  isEmpty:
                                      controller.selectedYear.value.isEmpty,
                                  onTap: () =>
                                      controller.showYearSheet(context),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // Licensing & Certifications
                  const Text('Licensing & Certifications',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 16),

                  _buildLabel('Specific Certifications'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: controller.certificationController,
                      hint: 'e.g. Certified Professional Coach'),
                  const SizedBox(height: 20),

                  _buildLabel('Registering Authority'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: controller.registeringAuthorityController,
                      hint: 'e.g. RCI, ICF'),
                  const SizedBox(height: 20),

                  // License — optional
                  Row(
                    children: [
                      const Text('License Number',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      const SizedBox(width: 6),
                      Text(' - OPTIONAL',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: controller.licenseController,
                      hint: 'Enter license number if applicable'),
                  const SizedBox(height: 20),

                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            size: 18, color: Color(0xFF0D9488)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Providing accurate qualification details helps us build trust with patients and ensures you are matched with relevant cases.',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildNextButton(onTap: controller.goToNext),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step, int total) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: step / total,
        minHeight: 5,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
          fontFamily: 'Mulish', fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: isEmpty ? Colors.grey.shade400 : Colors.black87)),
            ),
            Icon(Icons.keyboard_arrow_down,
                color: Colors.grey.shade500, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Next Step',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
