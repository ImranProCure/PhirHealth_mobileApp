import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coach_step3_controller.dart';

class CoachStep3View extends GetView<CoachStep3Controller> {
  const CoachStep3View({super.key});

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
        title: const Text('Step 3 of 6',
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
                    child: Text('Expertise',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(3, 6),
                  const SizedBox(height: 24),

                  // Specializations
                  const Text('Specializations',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 6),
                  Text('Select areas where you have core expertise.',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.specializationList.map((s) {
                          final sel =
                              controller.selectedSpecializations.contains(s);
                          return _buildChip(
                              label: s,
                              selected: sel,
                              onTap: () => controller.toggleSpecialization(s));
                        }).toList(),
                      )),
                  const SizedBox(height: 24),

                  // Target Audience
                  const Text('Target Audience',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.audienceList.map((a) {
                          final sel = controller.selectedAudience.contains(a);
                          return _buildChip(
                              label: a,
                              selected: sel,
                              onTap: () => controller.toggleAudience(a));
                        }).toList(),
                      )),
                  const SizedBox(height: 24),

                  // Experience Metrics
                  const Text('Experience Metrics',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 12),
                  _buildLabel('Total Years Experience'),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Obx(() => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFF0D9488),
                                inactiveTrackColor: Colors.grey.shade300,
                                thumbColor: const Color(0xFF0D9488),
                                overlayColor:
                                    const Color(0xFF0D9488).withOpacity(0.2),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: controller.yearsExperience.value,
                                min: 0,
                                max: 50,
                                divisions: 50,
                                onChanged: (v) =>
                                    controller.yearsExperience.value = v,
                              ),
                            )),
                        Obx(() => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('0 yrs',
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
                                  Text(
                                    '${controller.yearsExperience.value.toInt()} Years',
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0D9488)),
                                  ),
                                  Text('50 yrs',
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Colors.grey.shade500)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Type of Experience
                  const Text('Type of Experience',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.expTypeList.map((e) {
                          final sel = controller.selectedExpTypes.contains(e);
                          return _buildChip(
                              label: e,
                              selected: sel,
                              onTap: () => controller.toggleExpType(e));
                        }).toList(),
                      )),
                  const SizedBox(height: 20),

                  _buildLabel('Current/Previous Workplaces'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: controller.workplacesController,
                      hint: 'e.g. Apollo Hospitals, Private Practice'),
                  const SizedBox(height: 20),

                  // Avg clients + Total hrs — side by side
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           _buildLabel('Avg. clients/mo'),
                  //           const SizedBox(height: 8),
                  //           _buildTextField(
                  //               controller: controller.avgClientsController,
                  //               hint: '20',
                  //               keyboardType: TextInputType.number),
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           _buildLabel('Total 1-on1 hrs'),
                  //           const SizedBox(height: 8),
                  //           _buildTextField(
                  //               controller: controller.totalHrsController,
                  //               hint: '1500',
                  //               keyboardType: TextInputType.number),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 32),
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

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : Colors.grey.shade300,
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
                color: selected ? const Color(0xFF0D9488) : Colors.transparent,
                border: Border.all(
                  color:
                      selected ? const Color(0xFF0D9488) : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        selected ? const Color(0xFF0D9488) : Colors.black87)),
          ],
        ),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
