import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';

import '../controllers/digital_readiness_edit_controller.dart';

class DigitalReadinessEditView extends GetView<DigitalReadinessEditController> {
  const DigitalReadinessEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Edit Digital Readiness',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return _buildSkeleton();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// ================= TITLE =================
              const Center(
                child: Text(
                  'Clinic Setup & Consultation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 34),

              /// ================= CLINIC PHOTOS =================
              const Text(
                'Clinic Photos',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              Obx(() {
                final hasPhotos = controller.clinicPhotos.isNotEmpty ||
                    controller.existingClinicPhotos.isNotEmpty;

                return GestureDetector(
                  onTap: controller.pickClinicPhotos,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: !hasPhotos
                        ? const Column(
                            children: [
                              Icon(
                                Icons.add_a_photo_rounded,
                                size: 46,
                                color: Color(0xFF0D9488),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Upload Clinic Photos',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Reception, cabin, waiting area etc.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              // ===== EXISTING PHOTOS FROM SERVER =====
                              ...controller.existingClinicPhotos.map(
                                (url) => Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        ApiConstants.imageUrl(url),
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 110,
                                          height: 110,
                                          color: const Color(0xFFE5E7EB),
                                          child: const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removeExistingPhoto(url),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ===== NEWLY PICKED PHOTOS =====
                              ...controller.clinicPhotos.map(
                                (File image) => Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.file(
                                        image,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removePhoto(image),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }),

              const SizedBox(height: 34),

              /// ================= CONSULTATION FEE =================
              const Text(
                'Consultation Fee',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: controller.feeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixText: '₹ ',
                    hintText: '800',
                    hintStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ================= WAIT TIME =================
              const Text(
                'Average Wait Time',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: controller.waitTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixText: 'mins',
                    hintText: '20',
                    hintStyle: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              /// ================= UPDATE BUTTON =================
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 58,
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
                          : controller.updateDigitalReadiness,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Update',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            Center(child: _sBox(width: 220, height: 24, radius: 8)),

            const SizedBox(height: 34),

            // Clinic Photos label
            _sBox(width: 120, height: 16, radius: 6),
            const SizedBox(height: 14),

            // Photo upload box
            _sBox(width: double.infinity, height: 160, radius: 24),

            const SizedBox(height: 34),

            // Consultation Fee label
            _sBox(width: 140, height: 16, radius: 6),
            const SizedBox(height: 10),
            _sBox(width: double.infinity, height: 58, radius: 16),

            const SizedBox(height: 28),

            // Wait Time label
            _sBox(width: 150, height: 16, radius: 6),
            const SizedBox(height: 10),
            _sBox(width: double.infinity, height: 58, radius: 16),

            const SizedBox(height: 50),

            // Button
            _sBox(width: double.infinity, height: 58, radius: 30),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sBox({
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
}
