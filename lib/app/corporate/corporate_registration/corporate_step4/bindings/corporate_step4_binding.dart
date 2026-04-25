import 'package:get/get.dart';
import '../controllers/corporate_step4_controller.dart';

class CorporateStep4Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CorporateStep4Controller>(
      () => CorporateStep4Controller(),
    );
  }
}
