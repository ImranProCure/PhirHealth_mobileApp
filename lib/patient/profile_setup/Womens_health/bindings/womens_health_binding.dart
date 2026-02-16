import 'package:get/get.dart';
import '../controllers/womens_health_controller.dart';

class WomensHealthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WomensHealthController>(
      () => WomensHealthController(),
    );
  }
}
