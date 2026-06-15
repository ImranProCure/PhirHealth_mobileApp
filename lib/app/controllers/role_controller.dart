import 'package:get/get.dart';

enum UserRole {
  patient,
  doctor,
  partner,
  coach,
  corporate,
}

// Partner ke 4 sub-types
enum PartnerType {
  clinic,
  hospital,
  pharmacy,
  lab,
}

class RoleController extends GetxController {
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);
  final Rx<PartnerType?> selectedPartnerType = Rx<PartnerType?>(null);

  // Role select karo
  void selectRole(UserRole role) {
    selectedRole.value = role;
    // Agar partner nahi select kiya toh partnerType reset karo
    if (role != UserRole.partner) {
      selectedPartnerType.value = null;
    }
  }

  // Partner type select karo (sirf tab call karo jab role == partner ho)
  void selectPartnerType(PartnerType type) {
    if (selectedRole.value == UserRole.partner) {
      selectedPartnerType.value = type;
    }
  }

  // --- Getters ---
  UserRole? get role => selectedRole.value;
  PartnerType? get partnerType => selectedPartnerType.value;

  bool get isPatient => role == UserRole.patient;
  bool get isDoctor => role == UserRole.doctor;
  bool get isCoach => role == UserRole.coach;
  bool get isCorporate => role == UserRole.corporate;
  bool get isPartner => role == UserRole.partner;

  // Partner sub-type getters
  bool get isClinic => isPartner && partnerType == PartnerType.clinic;
  bool get isHospital => isPartner && partnerType == PartnerType.hospital;
  bool get isPharmacy => isPartner && partnerType == PartnerType.pharmacy;
  bool get isLab => isPartner && partnerType == PartnerType.lab;

  // Validation - kya selection complete hai?
  bool get isSelectionComplete {
    if (role == null) return false;
    if (role == UserRole.partner && partnerType == null) return false;
    return true;
  }
}
