abstract class Routes {
  static const SPLASH = '/';
  static const VERIFY_MOBILE = '/verify-mobile';
  static const DASHBOARD = '/dashboard';

  // patient
  static const PATIENT_IDENTITY_VITALS = '/patient/identity-vitals';
  static const PATIENT_MEDICAL_HISTORY = '/patient/medical-history';
  static const PATIENT_LIFESTYLE = '/patient/lifestyle';
  static const PATIENT_FAMILY_WELLBEING = '/patient/family-wellbeing';
  static const PATIENT_WOMENS_HEALTH = '/patient/Women-health';
  static const PATIENT_COMPLETION = '/patient/completion';

  // Doctor
  static const DOCTOR_REGISTRATION = '/doctor/registration';
  static const DOCTOR_EXPERIENCE = '/doctor/experience';
  static const DOCTOR_DIGITAL_READINESS = '/doctor/digital-readiness';
  static const DOCTOR_FINAL_VERIFICATION = '/doctor/final-verification';

  //Doctor Consult
  static const DOCTOR_CONSULT = '/doctor-consult';
  static const SELECT_DOCTOR = '/select-doctor';
  static const PROFILE_DETAILS = '/profile-details';
  static const ALL_SLOTS = '/all-slots';
  static const PATIENT_DETAILS = '/patient-details';
}
