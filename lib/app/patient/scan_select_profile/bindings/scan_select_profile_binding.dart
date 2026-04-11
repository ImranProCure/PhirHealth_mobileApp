import 'package:get/get.dart';
import 'package:sample/app/patient/scan_select_profile/controllers/scan_select_profile_controller.dart';

class ScanSelectProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanSelectProfileController>(
        () => ScanSelectProfileController());
  }
}
