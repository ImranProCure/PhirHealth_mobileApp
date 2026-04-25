import 'package:get/get.dart';
import '../controllers/corporate_step3_controller.dart';

class CorporateStep3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CorporateStep3Controller>(
      () => CorporateStep3Controller(),
    );
  }
}
