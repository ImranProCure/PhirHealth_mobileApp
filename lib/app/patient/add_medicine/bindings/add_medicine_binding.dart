import 'package:get/get.dart';
import '../controllers/add_medicine_controller.dart';

class AddMedicineBinding extends Bindings {
  @override
  void dependencies() =>
      Get.lazyPut<AddMedicineController>(() => AddMedicineController());
}
