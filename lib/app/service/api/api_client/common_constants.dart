class CommonApiConstants {
  const CommonApiConstants();

  // Authentication
  final String login = "/api/method/vhealthcare.api.patient.auth.login_otp.generate_otp";
  final String otpVerify = "/api/method/vhealthcare.api.patient.auth.login_otp.verify_otp";
  final String patientSignup = "/api/method/vhealthcare.api.patient.auth.create_patient.create_patient_basic";
  final String resendOtp = "/api/method/vhealthcare.api.patient.auth.login_otp.resend_otp";
  final String patientProfileEdit = "api/method/vhealthcare.api.patient.my_profile.update_profile.update_profile";
  // final String signup = "/api/method/vlms.api.authentication.signup";
  // final String logout = "/api/method/vlms.api.authentication.logout";
}
