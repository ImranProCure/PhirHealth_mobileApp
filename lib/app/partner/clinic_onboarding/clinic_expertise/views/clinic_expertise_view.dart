import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/clinic_expertise_controller.dart';

class ClinicExpertiseView extends GetView<ClinicExpertiseController> {
  const ClinicExpertiseView({super.key});

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
          'Step 2 of 4',
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
                      'Define your clinic\'s expertise.',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(2),
                  const SizedBox(height: 24),

                  // Consultation Types
                  const Text(
                    'Consultation Types',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Obx(() => Row(
                        children: [
                          // In Person Card
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.selectConsultationType('inperson'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: controller.selectedConsultationType
                                                .value ==
                                            'inperson'
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8F5F4),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.medical_services_outlined,
                                            size: 26,
                                            color: Color(0xFF0D9488),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: controller
                                                        .selectedConsultationType
                                                        .value ==
                                                    'inperson'
                                                ? const Color(0xFF0D9488)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: controller
                                                          .selectedConsultationType
                                                          .value ==
                                                      'inperson'
                                                  ? const Color(0xFF0D9488)
                                                  : Colors.grey.shade400,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: controller
                                                      .selectedConsultationType
                                                      .value ==
                                                  'inperson'
                                              ? const Icon(Icons.check,
                                                  size: 14, color: Colors.white)
                                              : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'In Person',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Physical clinic visitions',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Online Card
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.selectConsultationType('online'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: controller.selectedConsultationType
                                                .value ==
                                            'online'
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.person_outline,
                                            size: 26,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: controller
                                                        .selectedConsultationType
                                                        .value ==
                                                    'online'
                                                ? const Color(0xFF0D9488)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: controller
                                                          .selectedConsultationType
                                                          .value ==
                                                      'online'
                                                  ? const Color(0xFF0D9488)
                                                  : Colors.grey.shade400,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: controller
                                                      .selectedConsultationType
                                                      .value ==
                                                  'online'
                                              ? const Icon(Icons.check,
                                                  size: 14, color: Colors.white)
                                              : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Online',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Virtual HD consultations',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 24),

                  // Specializations Offered
                  const Text(
                    'Specializations Offered',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chips
                        Obx(() => controller.specializations.isEmpty
                            ? const SizedBox.shrink()
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.specializations
                                    .map((spec) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8F5F4),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                spec,
                                                style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              GestureDetector(
                                                onTap: () => controller
                                                    .removeSpecialization(spec),
                                                child: const Icon(Icons.close,
                                                    size: 14,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              )),
                        const SizedBox(height: 10),

                        // Add more input
                        TextField(
                          controller: controller.specializationInputController,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add more..',
                            hintStyle: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: controller.addSpecialization,
                          textInputAction: TextInputAction.done,
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
