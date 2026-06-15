import 'package:get/get.dart';
import '../controllers/hospital_verify_otp_controller.dart';

class HospitalVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalVerifyOtpController>(
      () => HospitalVerifyOtpController(),
    );
  }
}
