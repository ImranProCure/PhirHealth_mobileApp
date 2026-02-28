import 'package:get/get.dart';
import '../controllers/savings_offers_controller.dart';

class SavingsOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavingsOffersController>(() => SavingsOffersController());
  }
}
