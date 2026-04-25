import 'package:get/get.dart';
import '../controllers/inventory_offerings_controller.dart';

class InventoryOfferingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryOfferingsController>(
        () => InventoryOfferingsController());
  }
}
