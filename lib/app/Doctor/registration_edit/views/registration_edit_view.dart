import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/registration_edit_controller.dart';

class RegistrationEditView extends GetView<RegistrationEditController> {
  const RegistrationEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // ✅ 0 rakho
        surfaceTintColor: Colors.transparent, // ✅ yeh add karo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Registration',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return _buildSkeleton();
        }

        return SingleChildScrollView(
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

              const SizedBox(height: 34),

              // ===== PROFILE IMAGE =====
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
                              : controller.existingImageUrl.value.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        controller.existingImageUrl.value,
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                        errorBuilder: (_, __, ___) => Center(
                                          child: Image.asset(
                                            'assets/icons/account_circle.png',
                                            width: 60,
                                          ),
                                        ),
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

              // ===== MOBILE — READ ONLY =====
              _title('Mobile Number'),
              const SizedBox(height: 10),
              _field(
                readOnly: true,
                child: Row(
                  children: [
                    const Text(
                      '+91',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
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
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          color: Color(0xFF9CA3AF),
                        ),
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
                    const Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== EMAIL — READ ONLY =====
              _title('Email Address'),
              const SizedBox(height: 10),
              _field(
                readOnly: true,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.emailController,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          color: Color(0xFF9CA3AF),
                        ),
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
                    const Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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

              Obx(
                () => SizedBox(
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
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.updateProfile,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Update',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // ===== SKELETON =====
  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _skeletonBox(width: 180, height: 24, radius: 8),
            const SizedBox(height: 34),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _skeletonBox(width: 120, height: 18, radius: 6),
            const SizedBox(height: 8),
            _skeletonBox(width: 200, height: 14, radius: 6),
            const SizedBox(height: 40),
            ..._skeletonFields(7),
            const SizedBox(height: 42),
            _skeletonBox(width: double.infinity, height: 56, radius: 30),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  List<Widget> _skeletonFields(int count) {
    return List.generate(count, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(width: 120, height: 14, radius: 6),
          const SizedBox(height: 10),
          _skeletonBox(width: double.infinity, height: 56, radius: 14),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
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

  Widget _field({required Widget child, bool readOnly = false}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: readOnly ? const Color(0xFFF3F4F6) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }
}
