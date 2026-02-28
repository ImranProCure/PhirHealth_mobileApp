import 'package:get/get.dart';
import '../controllers/visit_details_controller.dart';

class VisitDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<VisitDetailsController>(
      VisitDetailsController(),
    );
  }
}
