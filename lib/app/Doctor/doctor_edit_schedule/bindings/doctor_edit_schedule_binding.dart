import 'package:get/get.dart';
import '../controllers/doctor_edit_schedule_controller.dart';

class DoctorEditScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorEditScheduleController>(
        () => DoctorEditScheduleController());
  }
}
