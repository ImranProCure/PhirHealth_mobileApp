import 'package:get/get.dart';
import '../controllers/operation_tech_controller.dart';

class OperationTechBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OperationTechController>(
      () => OperationTechController(),
    );
  }
}
