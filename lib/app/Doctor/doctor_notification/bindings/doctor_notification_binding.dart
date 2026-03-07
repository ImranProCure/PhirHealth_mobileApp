import 'package:get/get.dart';
import '../controllers/doctor_notification_controller.dart';

class DoctorNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorNotificationController>(
        () => DoctorNotificationController());
  }
}
