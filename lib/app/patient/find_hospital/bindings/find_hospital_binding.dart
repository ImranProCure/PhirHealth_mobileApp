import 'package:get/get.dart';
import '../controllers/find_hospital_controller.dart';

class FindHospitalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindHospitalController>(() => FindHospitalController());
  }
}
