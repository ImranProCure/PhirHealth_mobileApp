import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/corporate_step3_controller.dart';

class CorporateStep3View extends GetView<CorporateStep3Controller> {
  const CorporateStep3View({super.key});

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
        title: const Text(
          'Step 3 of 4',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
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
                    child: Text(
                      'Service Preferences',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(3),
                  const SizedBox(height: 24),

                  // Preferred Mode
                  const Text(
                    'Preferred Mode',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.modes.map((mode) {
                          final selected =
                              controller.preferredMode.value == mode;
                          return GestureDetector(
                            onTap: () => controller.selectMode(mode),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF0D9488)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected
                                          ? const Color(0xFF0D9488)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFF0D9488)
                                            : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: selected
                                        ? const Icon(Icons.check,
                                            size: 13, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    mode,
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? const Color(0xFF0D9488)
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 20),

                  // Expected Timeline — date picker
                  _buildLabel('Expected timeline'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: Obx(() => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.expectedTimeline.value,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const Icon(Icons.calendar_month_outlined,
                                  color: Color(0xFF0D9488), size: 20),
                            ],
                          ),
                        )),
                  ),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // Budget & Experience
                  const Text(
                    'Budget & Experience',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Indicative Budget — rupee prefix
                  _buildLabel('Indicative Budget'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.budgetController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter amount',
                              hintStyle: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Familiar with EMR toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Familiar with EMR Systems?',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Obx(() => Switch(
                              value: controller.familiarWithEMR.value,
                              onChanged: (v) =>
                                  controller.familiarWithEMR.value = v,
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xFF0D9488),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade300,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Experience Details
                  _buildLabel('Experience Details'),
                  const SizedBox(height: 8),
                  _buildMultilineField(
                    controller: controller.experienceController,
                    hint: 'Briefly describe your previous vendors...',
                    minLines: 4,
                  ),
                  const SizedBox(height: 20),

                  // Key Success Metrics (KPIs)
                  _buildLabel('Key Success Metrics (KPIs)'),
                  const SizedBox(height: 8),
                  _buildMultilineField(
                    controller: controller.kpiController,
                    hint:
                        'e.g., 90% Training Attendance, Position closure in 15 days..',
                    minLines: 4,
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

  Widget _buildProgressBar(int step) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: step / 4,
        minHeight: 5,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMultilineField({
    required TextEditingController controller,
    required String hint,
    int minLines = 3,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: null,
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
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
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
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
