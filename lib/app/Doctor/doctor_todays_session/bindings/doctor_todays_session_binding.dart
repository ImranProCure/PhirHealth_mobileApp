import 'package:get/get.dart';
import '../controlllers/doctor_todays_session_controller.dart';

class DoctorTodaysSessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorTodaysSessionController>(
        () => DoctorTodaysSessionController());
  }
}
