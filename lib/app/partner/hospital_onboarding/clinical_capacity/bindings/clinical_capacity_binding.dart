import 'package:get/get.dart';
import '../controllers/clinical_capacity_controller.dart';

class ClinicalCapacityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicalCapacityController>(() => ClinicalCapacityController());
  }
}
