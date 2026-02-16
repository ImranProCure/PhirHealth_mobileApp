import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/final_verification_controller.dart';

class FinalVerificationView extends GetView<FinalVerificationController> {
  const FinalVerificationView({super.key});

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
          'Step 4 of 4',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ================= TITLE =================
            const Center(
              child: Text(
                'Final Verification',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= PROGRESS =================
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 4 / 4,
                minHeight: 6,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 30),

            // ================= LEGAL CHECK =================
            const Text(
              'Legal Check',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Have you ever faced disciplinary or legal action related to your medical practice?',
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            Obx(() => Row(
                  children: [
                    _chip(
                      label: "Yes",
                      selected: controller.hasLegalIssue.value == true,
                      onTap: () => controller.hasLegalIssue.value = true,
                    ),
                    const SizedBox(width: 12),
                    _chip(
                      label: "No",
                      selected: controller.hasLegalIssue.value == false,
                      onTap: () => controller.hasLegalIssue.value = false,
                    ),
                  ],
                )),

            const SizedBox(height: 20),

            // ================= DETAILS IF YES =================
            Obx(() {
              if (controller.hasLegalIssue.value != true) {
                return const SizedBox();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Please provide details',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red),
                    ),
                    child: TextField(
                      controller: controller.legalDetailsController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Provide a brief explanation of the incident and current status...',
                      ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),

            // ================= MOTIVATION =================
            const Text(
              'Motivation',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Why do you want to join PHIR Health?',
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: controller.motivationController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Tell us about your passion for healthcare and what attracts you to our platform...',
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================= CONFIRMATION BOX =================
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE6F5F3),
                      Color(0xFFE8F0FF),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFBFD9D6),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.isConfirmed.value =
                            !controller.isConfirmed.value;
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFF0D9488),
                            width: 1.5,
                          ),
                          color: controller.isConfirmed.value
                              ? const Color(0xFF0D9488)
                              : Colors.transparent,
                        ),
                        child: controller.isConfirmed.value
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "I confirm that the information provided is true and correct",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "By submitting this application, your acknowledge that any false information or misrepresentation may lead to immediate disqualification or termination of contract.",
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ================= SUBMIT BUTTON =================
            const SizedBox(height: 24),

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
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: controller.submitApplication,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit Application for Review',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.verified_user, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "SECURE MEDICAL VERIFICATION",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ================= CHIP =================
  Widget _chip({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6F5F3) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color: const Color(0xFF0D9488),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF0D9488) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
