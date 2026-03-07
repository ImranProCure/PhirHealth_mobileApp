import 'package:get/get.dart';
import '../controllers/select_counsellor_controller.dart';

class SelectCounsellorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectCounsellorController>(
      () => SelectCounsellorController(),
    );
  }
}
