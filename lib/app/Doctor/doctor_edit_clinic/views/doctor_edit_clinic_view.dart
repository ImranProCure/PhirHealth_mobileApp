import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import '../controllers/doctor_edit_clinic_controller.dart';

class DoctorEditClinicView extends GetView<DoctorEditClinicController> {
  const DoctorEditClinicView({super.key});

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
        centerTitle: true,
        title: const Text('Edit Clinic Profile',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D9488)),
          );
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== CLINIC NAME =====
                    _fieldLabel('Clinic Name'),
                    const SizedBox(height: 8),
                    _inputField(
                      ctrl: controller.clinicNameController,
                      hint: 'Evergreen Wellness Clinic',
                    ),
                    const SizedBox(height: 16),

                    // ===== ADDRESS LINE 1 =====
                    _fieldLabel('Address Line 1'),
                    const SizedBox(height: 8),
                    _inputField(
                      ctrl: controller.addressLine1Controller,
                      hint: '25, Vijay Nagar',
                    ),
                    const SizedBox(height: 16),

                    // ===== ADDRESS LINE 2 =====
                    _fieldLabel('Address Line 2'),
                    const SizedBox(height: 8),
                    _inputField(
                      ctrl: controller.addressLine2Controller,
                      hint: 'Near Mall',
                    ),
                    const SizedBox(height: 16),

                    // ===== CITY =====
                    _fieldLabel('City'),
                    const SizedBox(height: 8),
                    _inputField(
                      ctrl: controller.cityController,
                      hint: 'Indore',
                    ),
                    const SizedBox(height: 24),

                    // ===== CLINIC PHOTOS =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Clinic Photos',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black)),
                        Obx(() => Text(controller.photoCount,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF6B7280)))),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Photo grid row
                    Obx(() => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Add Photo button
                                GestureDetector(
                                  onTap: controller.addPhoto,
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF0D9488),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo_outlined,
                                            color: Color(0xFF0D9488), size: 26),
                                        SizedBox(height: 6),
                                        Text('Add Photo',
                                            style: TextStyle(
                                                fontFamily: 'Mulish',
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF0D9488))),
                                      ],
                                    ),
                                  ),
                                ),

                                // Photos
                                ...List.generate(controller.clinicPhotos.length,
                                    (i) {
                                  final photo = controller.clinicPhotos[i];
                                  final bool isNetwork =
                                      photo.startsWith('/files/');
                                  final bool isLocal =
                                      !isNetwork && !photo.startsWith('http');

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        margin:
                                            const EdgeInsets.only(right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color(0xFFE0F2F1),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: isLocal
                                              ? Image.file(
                                                  File(photo),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  isNetwork
                                                      ? ApiConstants.imageUrl(
                                                          photo)
                                                      : photo,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                          Icons.image_outlined,
                                                          color:
                                                              Color(0xFF0D9488),
                                                          size: 32),
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -8,
                                        right: 6,
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.removePhoto(i),
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFEF4444),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 24),

                    // ===== CLINIC FEES =====
                    const Text('Clinic Fees',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 12),

                    _feeRow(
                      label: 'Clinic Fee',
                      sublabel: 'Recurring check-ups',
                      ctrl: controller.clinicFeeController,
                    ),
                    const SizedBox(height: 10),
                    _feeRow(
                      label: 'Video Fee',
                      sublabel: 'Telemedicine rate',
                      ctrl: controller.videoFeeController,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ===== BOTTOM BUTTONS =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: controller.cancel,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF0D9488), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D9488))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => SizedBox(
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF00897B),
                                Color(0xFF1565C0)
                              ]),
                            ),
                            child: ElevatedButton(
                              onPressed: controller.isSaving.value
                                  ? null
                                  : controller.save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: controller.isSaving.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2)
                                  : const Text('Save',
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white)),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(label,
        style: const TextStyle(
            fontFamily: 'Mulish', fontSize: 13, color: Color(0xFF374151)));
  }

  Widget _inputField(
      {required TextEditingController ctrl, required String hint}) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
      ),
    );
  }

  Widget _feeRow({
    required String label,
    required String sublabel,
    required TextEditingController ctrl,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const SizedBox(height: 2),
              Text(sublabel,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
            ],
          ),
          Container(
            width: 110,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Text('₹ ',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
