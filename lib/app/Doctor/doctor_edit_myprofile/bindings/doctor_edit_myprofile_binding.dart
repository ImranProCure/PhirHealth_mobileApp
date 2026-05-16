import 'package:get/get.dart';
import '../controllers/doctor_edit_myprofile_controller.dart';

class DoctorEditMyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorEditMyProfileController>(
      () => DoctorEditMyProfileController(),
    );
  }
}
