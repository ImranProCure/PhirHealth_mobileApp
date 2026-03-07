import 'package:get/get.dart';
import '../controllers/doctor_requests_controller.dart';

class DoctorRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorRequestsController>(() => DoctorRequestsController());
  }
}
