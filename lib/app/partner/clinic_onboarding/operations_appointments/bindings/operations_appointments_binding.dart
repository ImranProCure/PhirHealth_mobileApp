import 'package:get/get.dart';
import '../controllers/operations_appointments_controller.dart';

class OperationsAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OperationsAppointmentsController>(
        () => OperationsAppointmentsController());
  }
}
