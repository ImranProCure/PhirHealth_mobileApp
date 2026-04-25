import 'package:get/get.dart';
import '../controllers/clinic_expertise_controller.dart';

class ClinicExpertiseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicExpertiseController>(() => ClinicExpertiseController());
  }
}
