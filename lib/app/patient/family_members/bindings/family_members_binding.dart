import 'package:get/get.dart';
import '../controllers/family_members_controller.dart';

class FamilyMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyMembersController>(() => FamilyMembersController());
  }
}
