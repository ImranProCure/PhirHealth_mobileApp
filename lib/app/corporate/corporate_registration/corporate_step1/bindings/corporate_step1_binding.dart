import 'package:get/get.dart';
import '../controllers/corporate_step1_controller.dart';

class CorporateStep1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CorporateStep1Controller>(
      () => CorporateStep1Controller(),
    );
  }
}
