import 'package:get/get.dart';
import '../controllers/hospital_details_controller.dart';

class HospitalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalDetailsController>(() => HospitalDetailsController());
  }
}
