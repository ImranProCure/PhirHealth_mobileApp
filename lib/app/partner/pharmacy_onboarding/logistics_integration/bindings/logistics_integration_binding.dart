import 'package:get/get.dart';
import '../controllers/logistics_integration_controller.dart';

class LogisticsIntegrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogisticsIntegrationController>(
        () => LogisticsIntegrationController());
  }
}
