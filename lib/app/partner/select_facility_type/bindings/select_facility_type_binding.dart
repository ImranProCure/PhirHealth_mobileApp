import 'package:get/get.dart';
import '../controllers/select_facility_type_controller.dart';

class SelectFacilityTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectFacilityTypeController>(
        () => SelectFacilityTypeController());
  }
}
