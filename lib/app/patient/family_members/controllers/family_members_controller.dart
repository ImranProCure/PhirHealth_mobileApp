import 'package:get/get.dart';

class FamilyMembersController extends GetxController {
  final RxList<Map<String, dynamic>> members = <Map<String, dynamic>>[
    {
      'name': 'Rahul Verma',
      'relation': 'My Self',
      'phirId': 'PH28-1029-44',
      'initials': 'RV',
    },
    {
      'name': 'Rakesh Verma',
      'relation': 'Father',
      'phirId': 'PH28-1029-44',
      'initials': 'BV',
    },
    {
      'name': 'Shalini Verma',
      'relation': 'Mother',
      'phirId': 'PH28-1029-44',
      'initials': 'SV',
    },
  ].obs;

  void addNewMember() => Get.toNamed('/add-family-member');
}
