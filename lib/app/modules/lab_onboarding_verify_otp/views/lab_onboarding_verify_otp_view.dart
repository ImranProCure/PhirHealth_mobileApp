import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/lab_onboarding_verify_otp_controller.dart';

class LabOnboardingVerifyOtpView extends StatelessWidget {
  const LabOnboardingVerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabOnboardingVerifyOtpController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Title ───────────────────────────────────────────────
                    const Text(
                      'Verify Mobile Number',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Subtitle ────────────────────────────────────────────
                    Obx(() => RichText(
                          text: TextSpan(
                            text: 'Please enter the 6-digit code sent to\n',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6B7280),
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: controller.mobileNumber.value,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 40),

                    // ── OTP Boxes ───────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        controller.otpLength,
                        (index) => SizedBox(
                          width: 50,
                          child: TextField(
                            controller: controller.otpControllers[index],
                            focusNode: controller.otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              counterText: '',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFE5E7EB), width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF0D9488), width: 2),
                              ),
                            ),
                            onChanged: (value) =>
                                controller.onOtpFieldChanged(value, index),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Timer / Resend ──────────────────────────────────────
                    Center(
                      child: Obx(() {
                        if (controller.canResend.value) {
                          return TextButton(
                            onPressed: controller.resendOtp,
                            child: const Text(
                              'Resend code',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D9488),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          );
                        } else {
                          return Text(
                            'Resend code ${controller.formattedTime}',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6B7280),
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // ── Verify Button ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Obx(() {
                final isEnabled = controller.isButtonEnabled.value;
                final isLoading = controller.isLoading.value;

                return Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isEnabled
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF00786F),
                              Color(0xFF009689),
                              Color(0xFF1447E6),
                            ],
                          )
                        : null,
                    color: isEnabled ? null : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: isEnabled
                        ? [
                            BoxShadow(
                              color: const Color(0xFF00786F).withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: (isEnabled && !isLoading)
                          ? controller.verifyOtp
                          : null,
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Verify & Complete Registration',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isEnabled
                                      ? Colors.white
                                      : const Color(0xFF9CA3AF),
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
