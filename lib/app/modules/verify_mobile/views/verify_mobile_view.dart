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
                    Text(
                      'verify_title'.tr,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle with phone number + edit icon
                    Obx(() => RichText(
                          text: TextSpan(
                            text: 'verify_subtitle'.tr,
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
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Image.asset(
                                      'assets/icons/draft_orders.png',
                                      width: 16,
                                      height: 16,
                                      color: const Color(0xFF0D9488),
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.edit_outlined,
                                        size: 16,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'verify_terms_prefix'.tr,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'verify_terms'.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: 'verify_and'.tr),
                        TextSpan(
                          text: 'verify_privacy'.tr,
                          style: const TextStyle(
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0D9488), width: 2),
          ),
        ),
        onChanged: (value) => controller.onOtpFieldChanged(value, index),
      ),
    );
  }
}

class _TimerAndResendRow extends GetView<VerifyMobileController> {
  const _TimerAndResendRow();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (controller.canResend.value) {
          return TextButton(
            onPressed: controller.resendOtp,
            child: Text(
              'verify_resend'.tr,
              style: const TextStyle(
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
            '${'verify_resend'.tr} ${controller.formattedTime}',
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
      final isLoading = controller.isLoading.value;

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
            onTap: (isEnabled && !isLoading) ? controller.verifyOtp : null,
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
                      'verify_btn'.tr,
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
