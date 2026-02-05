import 'package:get/get.dart';
import '../controllers/verify_mobile_controller.dart';

class VerifyMobileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyMobileController>(() => VerifyMobileController());
  }
}
