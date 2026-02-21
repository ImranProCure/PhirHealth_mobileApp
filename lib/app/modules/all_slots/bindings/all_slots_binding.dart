import 'package:get/get.dart';
import '../controllers/all_slots_controller.dart';

class AllSlotsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AllSlotsController>(
      AllSlotsController(),
    );
  }
}
