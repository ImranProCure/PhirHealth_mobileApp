class CommonApiConstants {
  const CommonApiConstants();

  // Authentication
  final String login =
      "/api/method/vhealthcare.api.patient.auth.login_otp.generate_otp";
  final String otpVerify =
      "/api/method/vhealthcare.api.patient.auth.login_otp.verify_otp";
  final String patientSignup =
      "/api/method/vhealthcare.api.patient.auth.create_patient.create_patient_basic";
  final String resendOtp =
      "/api/method/vhealthcare.api.patient.auth.login_otp.resend_otp";
  final String patientProfileEdit =
      "/api/method/vhealthcare.api.patient.my_profile.update_profile.update_profile";
  final String patientProfileView =
      "/api/method/vhealthcare.api.patient.my_profile.my_profile.get_patient_profile";
  final String getexistingConditions =
      "/api/method/vhealthcare.api.patient.auth.create_patient.get_existing_medical_conditions";
  final String getAllergy =
      "/api/method/vhealthcare.api.patient.auth.create_patient.get_alleries_list";
  final String getSymstom =
      "/api/method/vhealthcare.api.patient.auth.create_patient.get_commom_symptoms";
  final String createConditions =
      "/api/method/vhealthcare.api.patient.auth.create_patient.create_new_medical_conditions";
  final String createAllergy =
      "/api/method/vhealthcare.api.patient.auth.create_patient.create_new_allergy";
  final String createSymton =
      "/api/method/vhealthcare.api.patient.auth.create_patient.create_common_symptoms?";

  // Doctor Consult
  final doctorList =
      "/api/method/vhealthcare.api.patient.doctor_consult.get_doctors.get_doctors_list";

  final specialistList =
      "/api/method/vhealthcare.api.patient.doctor_consult.get_speciality.get_specialities_list";

  final profileDoctorDetails =
      "/api/method/vhealthcare.api.patient.doctor_consult.dr_profile_details.get_doctor_profile";

  final submmitReview =
      "/api/method/vhealthcare.api.patient.doctor_consult.add_review.add_patient_review";

  final reviewListApi =
      "/api/method/vhealthcare.api.patient.doctor_consult.review_list.get_review_list";

  final relationListApi =
      "/api/method/vhealthcare.api.patient.doctor_consult.get_patient_relation.get_patient_relations";

  final relationAddApi =
      "/api/method/vhealthcare.api.patient.doctor_consult.patient_details.add_member_patient";

  final walletBalance =
      "/api/method/vhealthcare.api.patient.doctor_consult.get_wallet_balance.get_wallet_balance";

  final bookAppointment =
      "/api/method/vhealthcare.api.patient.doctor_consult.book_appointment.book_appointment";
}
