import 'package:get/get.dart';
import '../controllers/doctor_consult_controller.dart';

class DoctorConsultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorConsultController>(
      () => DoctorConsultController(),
    );
  }
}
