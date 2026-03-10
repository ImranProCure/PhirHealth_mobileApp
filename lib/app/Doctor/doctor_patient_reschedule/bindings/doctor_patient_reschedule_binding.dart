import 'package:get/get.dart';
import '../controllers/doctor_patient_reschedule_controller.dart';

class DoctorPatientRescheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorPatientRescheduleController>(
        () => DoctorPatientRescheduleController());
  }
}
