import 'package:get/get.dart';
import '../controllers/doctor_reviews_controller.dart';

class DoctorReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorReviewsController>(() => DoctorReviewsController());
  }
}
