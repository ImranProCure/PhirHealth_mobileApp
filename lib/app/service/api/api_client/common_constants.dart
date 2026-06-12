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

  // Doctor Auth — ADDED
  final String doctorGenerateOtp =
      "/api/method/vhealthcare.api.patient.auth.login_otp.generate_otp";
  final String doctorSignup =
      "/api/method/vhealthcare.api.doctor.dr_registration.dr.create_doctor";

  // Doctor Experience — ADDED
  final String getDoctorPracticePlace =
      "/api/method/vhealthcare.api.doctor.dr_registration.dr.get_current_practice_place";
  final String createDoctorPracticePlace =
      "/api/method/vhealthcare.api.doctor.dr_registration.dr.create_practice_place";

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

  // Counsellor Consult
  final counsallerList =
      "/api/method/vhealthcare.api.patient.counsellors.get_counsellor.get_counsellors_list";
  final specialistCousallerList =
      "/api/method/vhealthcare.api.patient.counsellors.get_speciality.get_specialities_list";
  final reviewListCounsallerApi =
      "/api/method/vhealthcare.api.patient.counsellors.review_list.get_review_list";
  final submitCounsallerReview =
      "/api/method/vhealthcare.api.patient.counsellors.add_review.add_patient_review";
  final profileCounsallerDetails =
      "/api/method/vhealthcare.api.patient.counsellors.dr_profile_details.get_doctor_profile";
  final bookCounsallerAppointment =
      "/api/method/vhealthcare.api.patient.counsellors.book_appointment.counsellor_book_appointment";

  // Doctor Visit
  final doctorVisitApi =
      "/api/method/vhealthcare.api.patient.my_doctor_visits.my_doctor_visits.get_my_doctor_visits";

  final doctorVisitDetail =
      "/api/method/vhealthcare.api.patient.my_doctor_visits.my_doctor_visit_details.get_visit_details";

  // Emergency Contacts
  final String getEmergencyContacts =
      "/api/method/vhealthcare.api.patient.my_profile.emergency_contacts.get_emergency_contacts";
  final String addEmergencyContact =
      "/api/method/vhealthcare.api.patient.my_profile.emergency_contacts.add_patient_emergency_contact";

  // Medical Records
  final String getMedicalRecords =
      "/api/method/vhealthcare.api.patient.my_medical_records.medical_records.get_medical_records";
  final String uploadMedicalFile =
      "/api/method/vhealthcare.api.patient.my_medical_records.upload_records.upload_medical_file";

  // Medicine Reminder
  final String addMedicine =
      "/api/method/vhealthcare.api.patient.medicine_reminder.add_medicine.add_medication";
  final String setSchedule =
      "/api/method/vhealthcare.api.patient.medicine_reminder.set_schedule.create_medication_request";
  final String getMyMedications =
      "/api/method/vhealthcare.api.patient.medicine_reminder.my_meds.get_my_medications";

  final String doctorOtpVerify =
      "/api/method/vhealthcare.api.patient.auth.verify_doctor_otp.verify_otp_doctor";
  // final String saveDoctorExperience =
  //     "/api/method/vhealthcare.api.doctor.dr_registration.dr.save_doctor_experience";

  // final String getDoctorExperience =
  //     "/api/method/vhealthcare.api.doctor.dr_registration.dr.get_doctor_experience";

  // Doctor My Profile
  final String getDoctorProfile =
      "/api/method/vhealthcare.api.doctor.my_profile.dr_profile.get_doctor_profile";

  final String updateDoctorProfile =
      '/api/method/vhealthcare.api.doctor.my_profile.update_profile.update_doctor_profile';

  final String getDoctorDashboard =
      "/api/method/vhealthcare.api.doctor.dr_dashboard.dashboard.get_doctor_dashboard";
  final String getAllBookings =
      '/api/method/vhealthcare.api.doctor.dr_dashboard.get_all_bookings.get_all_bookings';
  final String getPendingRequests =
      '/api/method/vhealthcare.api.doctor.pending_request.pending_request.get_pending_requests';

  final String acceptAppointment =
      '/api/method/vhealthcare.api.doctor.pending_request.pending_request.accept_appointment';
  final String cancelAppointment =
      '/api/method/vhealthcare.api.doctor.pending_request.pending_request.cancel_appointment';

  final String getAppointmentDetails =
      '/api/method/vhealthcare.api.doctor.pending_request.accept_booking.get_appointment_details';
  final String getConfirmedAppointmentDetails =
      '/api/method/vhealthcare.api.doctor.pending_request.accept_booking.get_confirmed_appointment_details';

  // common_constants.dart mein yeh add karo
  final String getAvailabilitySlots =
      '/api/method/vhealthcare.api.doctor.my_availabilty_slot.slot_details.get_my_availability_slots';

  final String getDayAvailabilitySlots =
      '/api/method/vhealthcare.api.doctor.my_availabilty_slot.edit_schedule.get_day_availability_slots';

  final String updateDayAvailabilitySlots =
      '/api/method/vhealthcare.api.doctor.my_availabilty_slot.edit_schedule.update_slots';
  final String getCurrentSessionDetails =
      '/api/method/vhealthcare.api.doctor.sessions.current_session.get_current_session_details';

  final String getAvailableSlots =
      '/api/method/vhealthcare.api.doctor.sessions.available_slots.get_available_slots';

  final String rescheduleAppointment =
      '/api/method/vhealthcare.api.doctor.sessions.reshedule_appointment.reschedule_appointment';
  final String getDoctorReviews =
      '/api/method/vhealthcare.api.doctor.Dr_review.patient_review.get_doctor_reviews';

  // Payment Phone Pay
  final String createPaymentlinkAPI =
      '/api/method/phonepe.api.create_payment_link.create_payment_link';
  final String createTransactionPaymentAPI =
      '/api/method/phonepe.api.payment_transaction.create_payment_transaction';
  final String statusPaymentAPI =
      '/api/method/phonepe.api.payment_transaction.create_payment_transaction';

  final String getClinicProfile =
      '/api/method/vhealthcare.api.doctor.edit_clinic_details.edit_get_clinic_details.get_clinic_profile';

  final String updateClinicProfile =
      '/api/method/vhealthcare.api.doctor.edit_clinic_details.edit_get_clinic_details.update_clinic_profile';
  final String saveNutritionPlan =
      '/api/method/vhealthcare.api.patient.ai_nutrition.ai_nutrition.save_nutrition_plan';

  final String getNutritionPlan =
      '/api/method/vhealthcare.api.patient.ai_nutrition.ai_nutrition.get_nutrition_plan';
  final String createLabProfile =
      '/api/method/vhealthcare.api.partnet.lab_onboarding.lab_onboarding.create_lab_profile';
  final String labOtpVerify =
      '/api/method/vhealthcare.api.patient.auth.lab_login_verify.verify_otp_lab';
  final String createPharmacyProfile =
      '/api/method/vhealthcare.api.partner.pharmacy.pharmacy_onboarding.create_pharmacy_profile';
  final String pharmacyOtpVerify =
      '/api/method/vhealthcare.api.patient.auth.pharmacy_otp_verify.verify_otp_pharmacy';
  final String createClinicProfile =
      '/api/method/vhealthcare.api.partner.clinic.clinic_onboarding.create_clinic_profile';
  final String clinicOtpVerify =
      '/api/method/vhealthcare.api.patient.auth.clinic_otp_verify.verify_otp_clinic';
  final String createHospitalProfile =
      '/api/method/vhealthcare.api.partner.hospital.hospital_onboarding.create_hospital_profile';
  final String hospitalOtpVerify =
      '/api/method/vhealthcare.api.patient.auth.hospital_verify.verify_otp_hospital';
  final String connectGoogleCalendar =
      '/api/method/vhealthcare.api.patient.google_calender.google_calender_api.connect_google_calendar';
  final String createDoctorSlots =
      '/api/method/vhealthcare.api.doctor.my_availabilty_slot.create_slots.create_doctor_slots';
}
