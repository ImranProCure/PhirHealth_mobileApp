import 'package:get/get.dart';
import '../controllers/lab_tests_controller.dart';

class LabTestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabTestsController>(() => LabTestsController());
  }
}
