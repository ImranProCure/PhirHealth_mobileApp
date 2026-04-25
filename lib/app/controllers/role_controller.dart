import 'package:get/get.dart';

enum UserRole {
  patient,
  doctor,
  partner,
  coach,
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
  bool get ispartner => role == UserRole.partner;
  bool get iscorporate => role == UserRole.corporate;
  bool get iscoach => role == UserRole.coach;
}
