import 'package:get/get.dart';
import '../controllers/verify_mobile_signup_controller.dart';

class VerifyMobileSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyMobileSignupController>(() => VerifyMobileSignupController());
  }
}
