import 'package:get/get.dart';
import '../controllers/add_family_members_controller.dart';

class AddFamilyMemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFamilyMemberController>(() => AddFamilyMemberController());
  }
}
