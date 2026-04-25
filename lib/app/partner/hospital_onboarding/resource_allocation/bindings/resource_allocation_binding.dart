import 'package:get/get.dart';
import '../controllers/resource_allocation_controller.dart';

class ResourceAllocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResourceAllocationController>(
        () => ResourceAllocationController());
  }
}
