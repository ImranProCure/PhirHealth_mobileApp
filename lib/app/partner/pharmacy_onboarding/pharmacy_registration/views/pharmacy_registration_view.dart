import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pharmacy_registration_controller.dart';

class PharmacyRegistrationView extends GetView<PharmacyRegistrationController> {
  const PharmacyRegistrationView({super.key});

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
          'Step 1 of 4',
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
                      'Pharmacy Registration',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(1),
                  const SizedBox(height: 24),

                  _buildLabel('Pharmacy Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.pharmacyNameController,
                    hint: 'e.g.',
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Type of Pharmacy',
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
                        children: controller.interestAreas.map((area) {
                          final selected =
                              controller.selectedInterests.contains(area);
                          return GestureDetector(
                            onTap: () => controller.toggleInterest(area),
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
                                    area,
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

                  _buildLabel('Contact Number'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.contactController,
                    hint: '+91 00000-00000',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.emailController,
                    hint: 'contact@pharmacy.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.addressController,
                    hint: 'Enter street address...',
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Website URL'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.websiteController,
                    hint: 'https://www.yourpharmacy.com',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 20),

                  // Upload Pharmacy Logo
                  GestureDetector(
                    onTap: controller.pickLogo,
                    child: Obx(() {
                      final path = controller.logoPath.value;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
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
                                      size: 40, color: Color(0xFF0D9488)),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Upload Pharmacy Logo',
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
                                    'Logo Selected ✓',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
