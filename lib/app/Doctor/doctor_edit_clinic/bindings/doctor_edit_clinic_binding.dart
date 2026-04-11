import 'package:get/get.dart';
import '../controllers/doctor_edit_clinic_controller.dart';

class DoctorEditClinicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorEditClinicController>(() => DoctorEditClinicController());
  }
}
