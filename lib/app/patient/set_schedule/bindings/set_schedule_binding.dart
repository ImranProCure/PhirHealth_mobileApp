import 'package:get/get.dart';
import '../controllers/set_schedule_controller.dart';

class SetScheduleBinding extends Bindings {
  @override
  void dependencies() =>
      Get.lazyPut<SetScheduleController>(() => SetScheduleController());
}
