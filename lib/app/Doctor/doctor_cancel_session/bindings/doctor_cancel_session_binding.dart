import 'package:get/get.dart';
import '../controllers/doctor_cancel_session_controller.dart';

class DoctorCancelSessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorCancelSessionController>(
        () => DoctorCancelSessionController());
  }
}
