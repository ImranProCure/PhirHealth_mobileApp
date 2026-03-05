import 'package:get/get.dart';
import '../controllers/fitness_tracker_controller.dart';

class FitnessTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FitnessTrackerController>(() => FitnessTrackerController());
  }
}
