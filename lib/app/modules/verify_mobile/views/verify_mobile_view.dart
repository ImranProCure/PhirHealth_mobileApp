import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_mobile_controller.dart';
import 'package:flutter/services.dart';

class VerifyMobileView extends GetView<VerifyMobileController> {
  const VerifyMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Heading
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

                    // Subtitle with phone number
                    Obx(
                      () => RichText(
                        text: TextSpan(
                          text: 'Please enter the 4-digit code sent to\n',
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
                      ),
                    ),

                    const SizedBox(height: 40),

                    // OTP Input Boxes
                    const _OtpInputRow(),

                    const SizedBox(height: 32),

                    // Timer & Resend
                    const _TimerAndResendRow(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Verify Button - Fixed at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const _VerifyButton(),
                  const SizedBox(height: 16),
                  // Terms text
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'By continuing, you agree to PHIR Health\'s\n',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Services',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// OTP Input Row Widget
class _OtpInputRow extends GetView<VerifyMobileController> {
  const _OtpInputRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        controller.otpLength,
        (index) => _OtpBox(index: index),
      ),
    );
  }
}

// Single OTP Box
// Single OTP Field with Underline
class _OtpBox extends GetView<VerifyMobileController> {
  final int index;

  const _OtpBox({required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF0D9488),
              width: 2,
            ),
          ),
        ),
        onChanged: (value) => controller.onOtpFieldChanged(value, index),
      ),
    );
  }
}

// Timer and Resend Row
class _TimerAndResendRow extends GetView<VerifyMobileController> {
  const _TimerAndResendRow();

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
class _VerifyButton extends GetView<VerifyMobileController> {
  const _VerifyButton();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEnabled = controller.isButtonEnabled.value;
      final isLoading = controller.isLoading.value; // ← ADD

      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00786F),
                    Color(0xFF009689),
                    Color(0xFF1447E6),
                  ],
                  stops: [0.0, 0.5, 1.0],
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
                : null, // ← block tap while loading
            child: Center(
              child: isLoading // ← SWAP text for spinner
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Verify & Proceed',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                            isEnabled ? Colors.white : const Color(0xFF9CA3AF),
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
