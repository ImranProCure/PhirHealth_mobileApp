import 'package:get/get.dart';
import '../controllers/doctor_profile_controller.dart';
import '../../../modules/google_calendar_controller_/google_calendar_controller.dart';

class DoctorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorProfileController>(() => DoctorProfileController());
    Get.lazyPut(() => GoogleCalendarController());
  }
}
