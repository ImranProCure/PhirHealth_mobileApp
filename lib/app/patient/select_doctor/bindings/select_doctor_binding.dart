import 'package:get/get.dart';
import '../controllers/select_doctor_controller.dart';

class SelectDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectDoctorController>(
      () => SelectDoctorController(),
    );
  }
}
