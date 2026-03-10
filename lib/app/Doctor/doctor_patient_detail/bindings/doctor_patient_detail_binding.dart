import 'package:get/get.dart';
import '../controllers/doctor_patient_detail_controller.dart';

class DoctorPatientDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorPatientDetailController>(
        () => DoctorPatientDetailController());
  }
}
