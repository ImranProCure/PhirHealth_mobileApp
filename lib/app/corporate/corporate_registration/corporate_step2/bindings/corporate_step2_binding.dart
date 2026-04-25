import 'package:get/get.dart';
import '../controllers/corporate_step2_controller.dart';

class CorporateStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CorporateStep2Controller>(
      () => CorporateStep2Controller(),
    );
  }
}
