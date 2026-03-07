import 'package:get/get.dart';
import '../controllers/doctor_availability_controller.dart';

class DoctorAvailabilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAvailabilityController>(
        () => DoctorAvailabilityController());
  }
}
