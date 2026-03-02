import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/identity_vitals_controller.dart';

class IdentityVitalsView extends GetView<IdentityVitalsController> {
  const IdentityVitalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Step 1 of 6 : Basic Profile',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body:SafeArea(
        bottom: true,
        child:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 14),

            // Title
            const Text(
              'Identity & Vitals',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 1 / 6,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xFF0D9488),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ================= PROFILE IMAGE WITH WHITE RING =================
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                // OUTER WHITE RING
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    // INNER LIGHT GREEN CIRCLE
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE6F5F3),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/account_circle.png',
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                ),

                // CAMERA BUTTON
                GestureDetector(
                  onTap: controller.pickProfileImage,
                  child: Container(
                    width: 32,
                    height: 32,
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

            const SizedBox(height: 20),

            const Text(
              'Upload Photo',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Add a face to your medical profile',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 30),

            // ================= FULL NAME =================
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Full Name',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller.nameController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ================= DATE OF BIRTH =================
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Date of Birth',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.dobController,
                      readOnly: true,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'MM / DD / YYYY',
                        hintStyle: TextStyle(
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: Image.asset(
                      'assets/icons/calendar_month.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gender',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: [
                  _genderPill(
                    label: 'Male',
                    icon: 'assets/icons/male.png',
                    value: Gender.male,
                  ),
                  const SizedBox(width: 10),
                  _genderPill(
                    label: 'Female',
                    icon: 'assets/icons/female.png',
                    value: Gender.female,
                  ),
                  const SizedBox(width: 10),
                  _genderPill(
                    label: 'Other',
                    icon: 'assets/icons/account_box.png',
                    value: Gender.other,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Height',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Obx(() {
                final inches = controller.heightInInches.value;
                final feet = inches ~/ 12;
                final rem = inches % 12;

                return Row(
                  children: [
                    // LEFT ICON BOX
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F5F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/measuring_tape.png',
                          width: 22,
                          height: 22,
                          color: const Color(0xFF0D9488),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // MIDDLE INPUT STYLE BOX
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "$feet'$rem",
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'ft',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // RIGHT FINAL VALUE
                    Text(
                      "$feet'$rem\" ft",
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Weight',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Obx(() {
                final weight = controller.weightKg.value;

                return Row(
                  children: [
                    // LEFT ICON BOX
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F5F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/scale.png',
                          width: 22,
                          height: 22,
                          color: const Color(0xFF0D9488),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // MIDDLE INPUT STYLE BOX
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "${weight.toStringAsFixed(1)}",
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'kg',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // RIGHT FINAL VALUE
                    Text(
                      "${weight.toStringAsFixed(1)} kg",
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Blood Group',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.bloodGroups.map((group) {
                  final isSelected = controller.bloodGroup.value == group;

                  return GestureDetector(
                    onTap: () => controller.bloodGroup.value = group,
                    child: Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF00786F),
                                  Color(0xFF009689),
                                  Color(0xFF1447E6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.white,
                        boxShadow: isSelected
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Text(
                        group,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00786F),
                      Color(0xFF009689),
                      Color(0xFF1447E6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x4D00786F),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
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
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      )),
    );
  }

  // ================= GENDER PILL HELPER =================
  Widget _genderPill({
    required String label,
    required String icon,
    required Gender value,
  }) {
    final isSelected = controller.gender.value == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.gender.value = value,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xFF00786F),
                      Color(0xFF009689),
                      Color(0xFF1447E6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: isSelected
                ? null
                : Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 20,
                height: 20,
                color: isSelected ? Colors.white : const Color(0xFF0D9488),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
