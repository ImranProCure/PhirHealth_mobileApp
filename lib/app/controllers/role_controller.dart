import 'package:get/get.dart';

enum UserRole {
  patient,
  doctor,
  partner,
  counsellor,
  corporate,
}

class RoleController extends GetxController {
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);

  void selectRole(UserRole role) {
    selectedRole.value = role;
  }

  UserRole? get role => selectedRole.value;

  bool get isPatient => role == UserRole.patient;
  bool get isDoctor => role == UserRole.doctor;
}
