import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/operation_tech_controller.dart';

class OperationTechView extends GetView<OperationTechController> {
  const OperationTechView({super.key});

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
                  // ── Centered Heading ──
                  const Center(
                    child: Text(
                      'Verification Details',
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

                  // PAN / GST Number
                  _buildLabel('PAN / GST Number'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.panGstController,
                    hint: 'Enter',
                  ),
                  const SizedBox(height: 20),

                  // Registration Number / License No.
                  _buildLabel('Registration Number / License No.'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.licenseController,
                    hint: 'KL-RE-2024-XXXX',
                  ),
                  const SizedBox(height: 20),

                  // NABL Accreditation Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NABL Accreditation Status',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Are you currently accredited?',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.nablAccredited.value = true,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: controller.nablAccredited.value
                                            ? const Color(0xFF0D9488)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: controller.nablAccredited.value
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.nablAccredited.value = false,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: !controller.nablAccredited.value
                                            ? const Color(0xFF0D9488)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              !controller.nablAccredited.value
                                                  ? Colors.white
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upload License Certificate
                  GestureDetector(
                    onTap: controller.pickCertificate,
                    child: Obx(() {
                      final path = controller.certificatePath.value;
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
                                    'Upload License Certificate',
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
                                    'Certificate Uploaded ✓',
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

                  // Info Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
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
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              children: const [
                                TextSpan(
                                    text:
                                        'All documents are processed via our '),
                                TextSpan(
                                  text: 'Secure Verification Gateway',
                                  style: TextStyle(
                                    color: Color(0xFF0D9488),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        '. Standard processing time is 48 hours.'),
                              ],
                            ),
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

          // Next Step Button — navigation via controller
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
