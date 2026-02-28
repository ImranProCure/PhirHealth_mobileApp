import 'package:get/get.dart';
import '../controllers/patient_details_controller.dart';

class PatientDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientDetailsController>(
      () => PatientDetailsController(),
    );
  }
}
