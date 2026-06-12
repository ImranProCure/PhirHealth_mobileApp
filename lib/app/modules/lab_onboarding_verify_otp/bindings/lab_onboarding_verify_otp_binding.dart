import 'package:get/get.dart';
import '../controllers/lab_onboarding_verify_otp_controller.dart';

class LabOnboardingVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabOnboardingVerifyOtpController>(
      () => LabOnboardingVerifyOtpController(),
    );
  }
}
