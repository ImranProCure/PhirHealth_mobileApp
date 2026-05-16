import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Step 1 of 4',
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
          children: [
            const SizedBox(height: 16),

            const Text(
              'Doctor Registration',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 1 / 4,
                minHeight: 6,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 34),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Obx(
                  () => Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F5F3),
                        ),
                        child: controller.profileImage.value != null
                            ? ClipOval(
                                child: Image.file(
                                  controller.profileImage.value!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              )
                            : Center(
                                child: Image.asset(
                                  'assets/icons/account_circle.png',
                                  width: 60,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.pickProfileImage,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0D9488),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/photo_camera.png',
                        width: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            const Text(
              'Upload Photo',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Add a face to your medical profile',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 40),

            // ===== FULL NAME =====
            _title('Full Name'),
            const SizedBox(height: 10),
            _field(
              child: TextField(
                controller: controller.fullNameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Dr. Rajesh Sharma',
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== DEGREE =====
            _title('Medical Degree'),
            const SizedBox(height: 10),
            _field(
              child: TextField(
                controller: controller.degreeController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'e.g. MBBS, MD, MS',
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== REG NUMBER =====
            _title('Registration Number'),
            const SizedBox(height: 10),
            _field(
              child: TextField(
                controller: controller.registrationNumberController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'MCI / State Council ID',
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== GRADUATION =====
            _title('Year of Graduation'),
            const SizedBox(height: 10),
            Obx(() {
              final year =
                  controller.graduationYear.value?.year.toString() ?? 'YYYY';
              return GestureDetector(
                onTap: controller.pickGraduationYear,
                child: _field(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        year,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: controller.graduationYear.value != null
                              ? Colors.black
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: Color(0xFF0D9488),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // ===== MOBILE =====
            _title('Mobile Number'),
            const SizedBox(height: 10),
            _field(
              child: Row(
                children: [
                  const Text(
                    '+91',
                    style: TextStyle(fontFamily: 'Mulish', fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: 24,
                    color: const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.mobileController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: '9876543210',
                        hintStyle: TextStyle(
                          fontFamily: 'Mulish',
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== EMAIL =====
            _title('Email Address'),
            const SizedBox(height: 10),
            _field(
              child: TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'doctor@example.com',
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== DOB =====
            _title('Date of Birth'),
            const SizedBox(height: 10),
            Obx(() {
              final dob = controller.birthDate.value;
              final text = dob != null
                  ? '${dob.day.toString().padLeft(2, '0')}/${dob.month.toString().padLeft(2, '0')}/${dob.year}'
                  : 'DD / MM / YYYY';
              return GestureDetector(
                onTap: controller.pickBirthDate,
                child: _field(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: dob != null
                              ? Colors.black
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: Color(0xFF0D9488),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 42),

            // ===== BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _field({required Widget child}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }
}
