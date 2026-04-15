class CommonApiConstants {
  const CommonApiConstants();

  // Authentication
  final String login = "/api/method/vhealthcare.api.patient.auth.login_otp.generate_otp";
  final String otpVerify = "/api/method/vhealthcare.api.patient.auth.login_otp.verify_otp";
  final String patientSignup = "/api/method/vhealthcare.api.patient.auth.create_patient.create_patient_basic";
  final String resendOtp = "/api/method/vhealthcare.api.patient.auth.login_otp.resend_otp";
  final String patientProfileEdit = "/api/method/vhealthcare.api.patient.my_profile.update_profile.update_profile";
  final String patientProfileView = "/api/method/vhealthcare.api.patient.my_profile.my_profile.get_patient_profile";
  final String getexistingConditions = "/api/method/vhealthcare.api.patient.auth.create_patient.get_existing_medical_conditions";
  final String getAllergy = "/api/method/vhealthcare.api.patient.auth.create_patient.get_alleries_list";
  final String getSymstom = "/api/method/vhealthcare.api.patient.auth.create_patient.get_commom_symptoms";
  final String createConditions = "/api/method/vhealthcare.api.patient.auth.create_patient.create_new_medical_conditions";
  final String createAllergy = "/api/method/vhealthcare.api.patient.auth.create_patient.create_new_allergy";
  final String createSymton = "/api/method/vhealthcare.api.patient.auth.create_patient.create_common_symptoms?";
  // final String signup = "/api/method/vlms.api.authentication.signup";
  // final String logout = "/api/method/vlms.api.authentication.logout";
}
