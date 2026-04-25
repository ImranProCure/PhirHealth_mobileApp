import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/corporate_step1_controller.dart';

class CorporateStep1View extends GetView<CorporateStep1Controller> {
  const CorporateStep1View({super.key});

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
                      'Corporate Registration',
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

                  // ── Avatar Picker ──
                  Center(
                    child: GestureDetector(
                      onTap: controller.pickAvatar,
                      child: Obx(() {
                        final path = controller.avatarPath.value;
                        return Stack(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8F5F4),
                              ),
                              child: path.isEmpty
                                  ? const Icon(
                                      Icons.person_outline,
                                      size: 44,
                                      color: Colors.black54,
                                    )
                                  : ClipOval(
                                      child: Image.file(
                                        File(path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF0D9488),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Company Details heading
                  const Center(
                    child: Text(
                      'Company Details',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Tell us about your organization\'s core profile',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Company Name
                  _buildLabel('Company Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.companyNameController,
                    hint: 'e.g. PHIR Global corp',
                  ),
                  const SizedBox(height: 20),

                  // Industry / Sector dropdown
                  _buildLabel('Industry / Sector'),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdownTile(
                        value: controller.selectedIndustry.value.isEmpty
                            ? 'Select your professional title'
                            : controller.selectedIndustry.value,
                        isEmpty: controller.selectedIndustry.value.isEmpty,
                        onTap: () => controller.showIndustrySheet(context),
                      )),
                  const SizedBox(height: 20),

                  // Company Size dropdown
                  _buildLabel('Company Size'),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdownTile(
                        value: controller.selectedCompanySize.value.isEmpty
                            ? 'Number of employees'
                            : controller.selectedCompanySize.value,
                        isEmpty: controller.selectedCompanySize.value.isEmpty,
                        onTap: () => controller.showCompanySizeSheet(context),
                      )),
                  const SizedBox(height: 20),

                  // Locations
                  _buildLabel('Locations'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.locationsController,
                    hint: 'e.g. New York, London',
                  ),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // POC Section
                  const Text(
                    'Point of Contact (POC)',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Primary Contact Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.primaryContactController,
                    hint: 'Full Legal Name',
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Designation'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.designationController,
                    hint: 'e.g. HR Director, CEO',
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Official Email ID'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.emailController,
                    hint: 'name@company.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Mobile Number'),
                  const SizedBox(height: 8),
                  // Phone field with India flag prefix
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text('🇮🇳',
                                  style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 6),
                              Text(
                                '+91',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.mobileController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: '9876543210',
                              hintStyle: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We will use these details for all primary communications regarding your corporate account.',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Colors.grey.shade500,
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

  Widget _buildDropdownTile({
    required String value,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  color: isEmpty ? Colors.grey.shade400 : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
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
