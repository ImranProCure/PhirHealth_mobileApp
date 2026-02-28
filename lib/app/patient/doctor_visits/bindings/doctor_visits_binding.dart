import 'package:get/get.dart';
import '../controllers/doctor_visits_controller.dart';

class DoctorVisitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorVisitsController>(
      () => DoctorVisitsController(),
    );
  }
}
