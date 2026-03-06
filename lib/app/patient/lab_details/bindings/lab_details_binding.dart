import 'package:get/get.dart';
import '../controllers/lab_details_controller.dart';

class LabDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabDetailsController>(() => LabDetailsController());
  }
}
