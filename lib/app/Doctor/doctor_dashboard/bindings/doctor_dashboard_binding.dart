import 'package:get/get.dart';
import '../controllers/doctor_dashboard_controller.dart';

class DoctorDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorDashboardController>(() => DoctorDashboardController());
  }
}
