import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hospital_legal_compliance_controller.dart';

class HospitalLegalComplianceView
    extends GetView<HospitalLegalComplianceController> {
  const HospitalLegalComplianceView({super.key});

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
          'Step 4 of 4',
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
                      'Legal & Compliance',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(4),
                  const SizedBox(height: 24),

                  // NABH Accreditation toggle
                  _buildServiceToggleCard(
                    icon: Icons.verified_outlined,
                    title: 'NABH Accreditation',
                    subtitle: 'National Accreditation Board for hospitals',
                    rxValue: controller.nabhAccreditation,
                    onChanged: (v) => controller.nabhAccreditation.value = v,
                  ),
                  const SizedBox(height: 20),

                  // Registration / License Number
                  _buildLabel('Registration/License Number'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.licenseNumberController,
                    hint: 'e.g.',
                  ),
                  const SizedBox(height: 20),

                  // Upload Hospital License
                  GestureDetector(
                    onTap: controller.pickHospitalLicense,
                    child: Obx(() {
                      final path = controller.hospitalLicensePath.value;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF0D9488),
                            width: 1.5,
                          ),
                        ),
                        child: path.isEmpty
                            ? Column(
                                children: [
                                  const Icon(Icons.cloud_upload_outlined,
                                      size: 44, color: Color(0xFF0D9488)),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Upload Hospital License',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'PNG, JPG UP To 10MB',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(path),
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'License Uploaded ✓',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to change',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Policy Agreement Checkbox
                  Obx(() => GestureDetector(
                        onTap: () => controller.agreedToPolicy.value =
                            !controller.agreedToPolicy.value,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5F4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: controller.agreedToPolicy.value
                                  ? const Color(0xFF0D9488)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: controller.agreedToPolicy.value
                                      ? const Color(0xFF0D9488)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: controller.agreedToPolicy.value
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                ),
                                child: controller.agreedToPolicy.value
                                    ? const Icon(Icons.check,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                    children: const [
                                      TextSpan(text: 'I agree to '),
                                      TextSpan(
                                        text: 'PHIR Policies',
                                        style: TextStyle(
                                          color: Color(0xFF0D9488),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ', including terms of digital health fulfilment, data privacy protocols, and automated settlement cycles.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildSubmitButton(onTap: controller.submitRegistration),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
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

  Widget _buildServiceToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool rxValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF0D9488)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
                value: rxValue.value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0D9488),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              )),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({required VoidCallback onTap}) {
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
                'Submit Registration',
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
