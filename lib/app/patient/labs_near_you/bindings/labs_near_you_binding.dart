import 'package:get/get.dart';
import '../controllers/labs_near_you_controller.dart';

class LabsNearYouBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabsNearYouController>(() => LabsNearYouController());
  }
}
