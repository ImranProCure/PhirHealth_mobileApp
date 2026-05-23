import 'package:get/get.dart';
import 'package:sample/app/Doctor/digital_readiness_edit/bindings/digital_readiness_edit_binding.dart';
import 'package:sample/app/Doctor/digital_readiness_edit/views/digital_readiness_edit_view.dart';
import 'package:sample/app/Doctor/doctor_appointment_accepted/bindings/doctor_appointment_accepted_binding.dart';
import 'package:sample/app/Doctor/doctor_edit_clinic/bindings/doctor_edit_clinic_binding.dart';
import 'package:sample/app/Doctor/doctor_edit_clinic/views/doctor_edit_clinic_view.dart';
import 'package:sample/app/Doctor/doctor_edit_myprofile/bindings/doctor_edit_myprofile_binding.dart';
import 'package:sample/app/Doctor/doctor_edit_myprofile/views/doctor_edit_myprofile_view.dart';
import 'package:sample/app/Doctor/experience_edit/bindings/experience_edit_binding.dart';
import 'package:sample/app/Doctor/experience_edit/views/experience_edit_view.dart';
import 'package:sample/app/Doctor/registration_edit/bindings/registration_edit_binding.dart';
import 'package:sample/app/Doctor/registration_edit/views/registration_edit_view.dart';
import 'package:sample/app/Doctor/see_all_appointments/controllers/see_all_appointments_controller.dart';
import 'package:sample/app/Doctor/see_all_appointments/views/see_all_appointments_view.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step1/bindings/coach_step1_binding.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step1/views/coach_step1_view.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step2/bindings/coach_step2_binding.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step2/views/coach_step2_view.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step3/bindings/coach_step3_binding.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step3/views/coach_step3_view.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step4/bindings/coach_step4_binding.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step4/views/coach_step4_view.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step5/bindings/coach_step5_binding.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step5/views/coach_step5_view.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step6/bindings/coach_step6_binding.dart';
import 'package:sample/app/coaches/coaches_registration/coach_step6/views/coach_step6_view.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step1/bindings/corporate_step1_binding.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step1/views/corporate_step1_view.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step2/bindings/corporate_step2_binding.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step2/views/corporate_step2_view.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step3/bindings/corporate_step3_binding.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step3/views/corporate_step3_view.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step4/bindings/corporate_step4_binding.dart';
import 'package:sample/app/corporate/corporate_registration/corporate_step4/views/corporate_step4_view.dart';
import 'package:sample/app/partner/clinic_onboarding/clinic_expertise/bindings/clinic_expertise_binding.dart';
import 'package:sample/app/partner/clinic_onboarding/clinic_expertise/views/clinic_expertise_view.dart';
import 'package:sample/app/partner/clinic_onboarding/clinic_legal_compliance/bindings/clinic_legal_compliance_binding.dart';
import 'package:sample/app/partner/clinic_onboarding/clinic_legal_compliance/views/clinic_legal_compliance_view.dart';
import 'package:sample/app/partner/clinic_onboarding/clinic_registration/bindings/clinic_registration_binding.dart';
import 'package:sample/app/partner/clinic_onboarding/clinic_registration/views/clinic_registration_view.dart';
import 'package:sample/app/partner/clinic_onboarding/operations_appointments/bindings/operations_appointments_binding.dart';
import 'package:sample/app/partner/clinic_onboarding/operations_appointments/views/operations_appointments_view.dart';
import 'package:sample/app/partner/hospital_onboarding/basic_information/bindings/basic_information_binding.dart';
import 'package:sample/app/partner/hospital_onboarding/basic_information/views/basic_information_view.dart';
import 'package:sample/app/partner/hospital_onboarding/clinical_capacity/bindings/clinical_capacity_binding.dart';
import 'package:sample/app/partner/hospital_onboarding/clinical_capacity/views/clinical_capacity_view.dart';
import 'package:sample/app/partner/hospital_onboarding/hospital_legal_compliance/bindings/hospital_legal_compliance_binding.dart';
import 'package:sample/app/partner/hospital_onboarding/hospital_legal_compliance/views/hospital_legal_compliance_view.dart';
import 'package:sample/app/partner/hospital_onboarding/resource_allocation/bindings/resource_allocation_binding.dart';
import 'package:sample/app/partner/hospital_onboarding/resource_allocation/views/resource_allocation_view.dart';
import 'package:sample/app/partner/lab_onboarding/basic_info/bindings/basic_info_binding.dart';
import 'package:sample/app/partner/lab_onboarding/basic_info/views/basic_info_view.dart';
import 'package:sample/app/partner/lab_onboarding/capabilities/bindings/capabilities_binding.dart';
import 'package:sample/app/partner/lab_onboarding/capabilities/views/capabilities_view.dart';
import 'package:sample/app/partner/lab_onboarding/operation_tech/bindings/operation_tech_binding.dart';
import 'package:sample/app/partner/lab_onboarding/operation_tech/views/operation_tech_view.dart';
import 'package:sample/app/partner/lab_onboarding/verification_details/bindings/verification_details_binding.dart';
import 'package:sample/app/partner/lab_onboarding/verification_details/views/verification_details_view.dart';
import 'package:sample/app/partner/pharmacy_onboarding/inventory_offerings%20/bindings/inventory_offerings_binding.dart';
import 'package:sample/app/partner/pharmacy_onboarding/inventory_offerings%20/views/inventory_offerings_view.dart';
import 'package:sample/app/partner/pharmacy_onboarding/legal_compliance/bindings/legal_compliance_binding.dart';
import 'package:sample/app/partner/pharmacy_onboarding/legal_compliance/views/legal_compliance_view.dart';
import 'package:sample/app/partner/pharmacy_onboarding/logistics_integration/bindings/logistics_integration_binding.dart';
import 'package:sample/app/partner/pharmacy_onboarding/logistics_integration/views/logistics_integration_view.dart';
import 'package:sample/app/partner/pharmacy_onboarding/pharmacy_registration/bindings/pharmacy_registration_binding.dart';
import 'package:sample/app/partner/pharmacy_onboarding/pharmacy_registration/views/pharmacy_registration_view.dart';
import 'package:sample/app/partner/select_facility_type/bindings/select_facility_type_binding.dart';
import 'package:sample/app/partner/select_facility_type/views/select_facility_type_view.dart';
import 'package:sample/app/patient/Dashboard/views/health_shorts.dart';
import 'package:sample/app/patient/cancer_general_assessment/bindings/cancer_general_assessment_binding.dart';
import 'package:sample/app/patient/cancer_general_assessment/views/cancer_general_assessment_view.dart';
import 'package:sample/app/patient/cancer_other_assessment/bindings/cancer_other_assessment_binding.dart';
import 'package:sample/app/patient/cancer_other_assessment/views/cancer_other_assessment_view.dart';
import 'package:sample/app/patient/cancer_skin_assessment/bindings/cancer_skin_assessment_binding.dart';
import 'package:sample/app/patient/cancer_skin_assessment/views/cancer_skin_assessment_view.dart';
import 'package:sample/app/patient/cancer_stomach_assessment/bindings/cancer_stomach_assessment_binding.dart';
import 'package:sample/app/patient/cancer_stomach_assessment/views/cancer_stomach_assessment_view.dart';
import 'package:sample/app/patient/cancer_throat_assessment%20/bindings/cancer_throat_assessment_binding.dart';
import 'package:sample/app/patient/cancer_throat_assessment%20/views/cancer_throat_assessment_view.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_tool/ascvd_binding.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_tool/ascvd_form_view.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_tool/ascvd_info_view.dart';
import 'package:sample/app/patient/deasis_tools/ascvd_tool/ascvd_result_view.dart';
import 'package:sample/app/patient/deasis_tools/main_tools.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_binding.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_form_view.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_info_view.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_result_view.dart';
import 'package:sample/app/patient/pre_scan_questions/bindings/pre_scan_questions_binding.dart';
import 'package:sample/app/patient/pre_scan_questions/views/pre_scan_questions_view.dart';
import 'package:sample/app/patient/profile_details/views/all_review.dart';
import 'package:sample/app/patient/scan_select_profile/bindings/scan_select_profile_binding.dart';
import 'package:sample/app/patient/scan_select_profile/views/scan_select_profile_view.dart';

import 'package:sample/app/patient/Dashboard/Bindings/dashboard_binding.dart';
import 'package:sample/app/patient/Dashboard/views/dashboard_view.dart';
import 'package:sample/app/patient/add_family_member/bindings/add_family_members_bindings.dart';
import 'package:sample/app/patient/add_family_member/views/add_family_members_view.dart';
import 'package:sample/app/patient/Lifestyle_edit/bindings/lifestyle_edit_binding.dart';
import 'package:sample/app/patient/Lifestyle_edit/views/lifestyle_edit_view.dart';
import 'package:sample/app/patient/counsellor_coaches/bindings/counsellor_coaches_binding.dart';
import 'package:sample/app/patient/counsellor_coaches/views/counsellor_coaches_view.dart';
import 'package:sample/app/patient/counsellor_profile_details/bindings/counsellor_profile_details_binding.dart';
import 'package:sample/app/patient/counsellor_profile_details/views/counsellor_profile_details_view.dart';
import 'package:sample/app/patient/family_members/bindings/family_members_binding.dart';
import 'package:sample/app/patient/family_members/views/family_members_view.dart';
import 'package:sample/app/patient/edit_profile/bindings/edit_profile_binding.dart';
import 'package:sample/app/patient/edit_profile/views/edit_profile_view.dart';
import 'package:sample/app/patient/family_wellbeing_edit/bindings%20/family_wellbeing_edit_binding.dart';
import 'package:sample/app/patient/family_wellbeing_edit/views/family_edit_wellbeing_view.dart';
import 'package:sample/app/patient/identity_vitals_edit/bindings/identity_vitals_edit_binding.dart';
import 'package:sample/app/patient/identity_vitals_edit/views/identity_edit_vitals_view.dart';
import 'package:sample/app/patient/medical_history_edit/bindings/edit_medical_history_binding.dart';
import 'package:sample/app/patient/medical_history_edit/views/edit_medical_history_view.dart';
import 'package:sample/app/patient/select_counsellor/bindings/select_counsellor_binding.dart';
import 'package:sample/app/patient/select_counsellor/views/select_counsellor_view.dart';

// app/modules
import '../modules/splash/views/splash_view.dart';

import '../modules/verify_mobile/views/verify_mobile_view.dart';
import '../modules/verify_mobile/bindings/verify_mobile_binding.dart';

import 'package:sample/app/patient/doctor_consult/bindings/doctor_consult_binding.dart';
import 'package:sample/app/patient/doctor_consult/views/doctor_consult_view.dart';

// ❗ patient is OUTSIDE app folder
import '../patient/patient_signup/identity_vitals/views/identity_vitals_view.dart';
import '../patient/patient_signup/identity_vitals/bindings/identity_vitals_binding.dart';

import '../patient/patient_signup/medical_history/views/medical_history_view.dart';
import '../patient/patient_signup/medical_history/bindings/medical_history_binding.dart';

import '../patient/patient_signup/Lifestyle/views/lifestyle_view.dart';
import '../patient/patient_signup/Lifestyle/bindings/lifestyle_binding.dart';

import '../patient/patient_signup/family_wellbeing/views/family_wellbeing_view.dart';
import '../patient/patient_signup/family_wellbeing/bindings /family_wellbeing_binding.dart';

import '../patient/patient_signup/Womens_health/views/womens_health_view.dart';
import '../patient/patient_signup/Womens_health/bindings/womens_health_binding.dart';

import '../patient/patient_signup/completion/views/completion_view.dart';
import '../patient/patient_signup/completion/bindings/completion_binding.dart';

import '../Doctor/doctor_signup/registration/views/registration_view.dart';
import '../Doctor/doctor_signup/registration/bindings/registration_binding.dart';

import '../Doctor/doctor_signup/experience/views/experience_view.dart';
import '../Doctor/doctor_signup/experience/bindings/experience_binding.dart';

import '../Doctor/doctor_signup/digital_readiness/views/digital_readiness_view.dart';
import '../Doctor/doctor_signup/digital_readiness/bindings/digital_readiness_binding.dart';

import '../Doctor/doctor_signup/final_verification/views/final_verification_view.dart';
import '../Doctor/doctor_signup/final_verification/bindings/final_verification_binding.dart';

import 'package:sample/app/patient/appointment_confirmed/views/appointment_confirmed_view.dart';

import 'package:sample/app/patient/profile_details/bindings/profile_details_binding.dart';
import 'package:sample/app/patient/profile_details/views/profile_details_view.dart';

import 'package:sample/app/patient/select_doctor/bindings/select_doctor_binding.dart';
import 'package:sample/app/patient/select_doctor/views/select_doctor_view.dart';

import 'package:sample/app/patient/all_slots/bindings/all_slots_binding.dart';
import 'package:sample/app/patient/all_slots/views/all_slots_views.dart';

import 'package:sample/app/patient/patient_details/bindings/patient_details_binding.dart';
import 'package:sample/app/patient/patient_details/views/patient_details_view.dart';

import 'package:sample/app/patient/booking_confirmation/bindings/booking_confirmation_binding.dart';
import 'package:sample/app/patient/booking_confirmation/views/booking_confirmation_view.dart';

import 'package:sample/app/patient/doctor_visits/bindings/doctor_visits_binding.dart';
import 'package:sample/app/patient/doctor_visits/views/doctor_visits_view.dart';

import 'package:sample/app/patient/visit_details/bindings/visit_details_binding.dart';
import 'package:sample/app/patient/visit_details/views/visit_details_view.dart';

import 'package:sample/app/patient/medical_records/bindings/medical_records_binding.dart';
import 'package:sample/app/patient/medical_records/views/medical_records_view.dart';

import 'package:sample/app/patient/save_report/bindings/save_report_binding.dart';
import 'package:sample/app/patient/save_report/views/save_report_view.dart';

import 'package:sample/app/patient/savings_offers/bindings/savings_offers_binding.dart';
import 'package:sample/app/patient/savings_offers/views/savings_offers_view.dart';

import 'package:sample/app/patient/my_profile/bindings/my_profile_binding.dart';
import 'package:sample/app/patient/my_profile/views/my_profile_view.dart';

import 'package:sample/app/patient/add_money/bindings/add_money_binding.dart';
import 'package:sample/app/patient/add_money/views/add_money_view.dart';

import 'package:sample/app/patient/wallet/bindings/wallet_binding.dart';
import 'package:sample/app/patient/wallet/views/wallet_view.dart';

import 'package:sample/app/patient/transaction_history/bindings/transaction_history_binding.dart';
import 'package:sample/app/patient/transaction_history/views/transaction_history_view.dart';

import 'package:sample/app/patient/cancer_lung_assessment/bindings/cancer_lung_assessment_binding.dart';
import 'package:sample/app/patient/cancer_lung_assessment/views/cancer_lung_assessment_view.dart';

import 'package:sample/app/patient/cancer_risk/bindings/cancer_risk_binding.dart';
import 'package:sample/app/patient/cancer_risk/views/cancer_risk_view.dart';

import 'package:sample/app/patient/cancer_risk_area/bindings/cancer_risk_area_binding.dart';
import 'package:sample/app/patient/cancer_risk_area/views/cancer_rish_area_view.dart';

import 'package:sample/app/patient/face_scan/bindings/face_scan_binding.dart';
import 'package:sample/app/patient/face_scan/views/face_scan_view.dart';

import 'package:sample/app/patient/scan_report/bindings/scan_report_binding.dart';
import 'package:sample/app/patient/scan_report/views/scan_report_view.dart';

import 'package:sample/app/patient/app_language/bindings/app_language_binding.dart';
import 'package:sample/app/patient/app_language/views/app_language_view.dart';

import 'package:sample/app/patient/emergency_contacts/bindings/emergency_contacts_binding.dart';
import 'package:sample/app/patient/emergency_contacts/views/emergency_contacts_view.dart';

import 'package:sample/app/patient/fitness_tracker/bindings/fitness_tracker_binding.dart';
import 'package:sample/app/patient/fitness_tracker/views/fitness_tracker_view.dart';

import 'package:sample/app/patient/bmi/bindings/bmi_binding.dart';
import 'package:sample/app/patient/bmi/views/bmi_view.dart';

import 'package:sample/app/patient/bmi_result/bindings/bmi_result_binding.dart';
import 'package:sample/app/patient/bmi_result/views/bmi_result_view.dart';

import 'package:sample/app/patient/cancer_result/bindings/cancer_result_binding.dart';
import 'package:sample/app/patient/cancer_result/views/cancer_result_view.dart';

import 'package:sample/app/patient/find_hospital/bindings/find_hospital_binding.dart';
import 'package:sample/app/patient/find_hospital/views/find_hospital_view.dart';

import 'package:sample/app/patient/hospital_details/bindings/hospital_details_binding.dart';
import 'package:sample/app/patient/hospital_details/views/hospital_details_view.dart';

import 'package:sample/app/patient/add_medicine/bindings/add_medicine_binding.dart';
import 'package:sample/app/patient/add_medicine/views/add_medicine_view.dart';

import 'package:sample/app/patient/medicine_reminder/bindings/medicine_reminder_binding.dart';
import 'package:sample/app/patient/medicine_reminder/views/medicine_reminder_view.dart';

import 'package:sample/app/patient/set_schedule/bindings/set_schedule_binding.dart';
import 'package:sample/app/patient/set_schedule/views/set_schedule_view.dart';

import 'package:sample/app/patient/ai_nutritionist/bindings/ai_nutritionist_binding.dart';
import 'package:sample/app/patient/ai_nutritionist/views/ai_nutritionist_view.dart';

import 'package:sample/app/patient/ai_nutritionist_result/bindings/ai_nutritionist_result_binding.dart';
import 'package:sample/app/patient/ai_nutritionist_result/views/ai_nutritionist_result_view.dart';

import 'package:sample/app/patient/lab_details/bindings/lab_details_binding.dart';
import 'package:sample/app/patient/lab_details/views/lab_details_view.dart';

import 'package:sample/app/patient/lab_tests/bindings/lab_tests_bindings.dart';
import 'package:sample/app/patient/lab_tests/views/lab_tests_view.dart';

import 'package:sample/app/patient/labs_near_you/bindings/labs_near_you_binding.dart';
import 'package:sample/app/patient/labs_near_you/views/labs_near_you_view.dart';

import 'package:sample/app/Doctor/doctor_dashboard/bindings/doctor_dashboard_binding.dart';
import 'package:sample/app/Doctor/doctor_dashboard/views/doctor_dashboard_view.dart';

import 'package:sample/app/Doctor/doctor_notification/bindings/doctor_notification_binding.dart';
import 'package:sample/app/Doctor/doctor_notification/views/doctor_notification_view.dart';

import 'package:sample/app/Doctor/doctor_profile/bindings/doctor_profile_binding.dart';
import 'package:sample/app/Doctor/doctor_profile/views/doctor_profile_view.dart';

import 'package:sample/app/Doctor/doctor_earnings/bindings/doctor_earnings_binding.dart';
import 'package:sample/app/Doctor/doctor_earnings/views/doctor_earnings_view.dart';

import 'package:sample/app/Doctor/doctor_availability/views/doctor_availability_view.dart';
import 'package:sample/app/Doctor/doctor_availability/bindings/doctor_availability_binding.dart';

import 'package:sample/app/Doctor/doctor_edit_schedule/bindings/doctor_edit_schedule_binding.dart';
import 'package:sample/app/Doctor/doctor_edit_schedule/views/doctor_edit_schedule_view.dart';

import 'package:sample/app/Doctor/doctor_reviews/bindings/doctor_reviews_binding.dart';
import 'package:sample/app/Doctor/doctor_reviews/views/doctor_reviews_view.dart';

import 'package:sample/app/Doctor/doctor_requests/bindings/doctor_requests_binding.dart';
import 'package:sample/app/Doctor/doctor_requests/views/doctor_requests_view.dart';

import 'package:sample/app/Doctor/doctor_accept_booking/bindings/doctor_accept_booking_binding.dart';
import 'package:sample/app/Doctor/doctor_accept_booking/views/doctor_accept_booking_view.dart';

import 'package:sample/app/Doctor/doctor_appointment_accepted/views/doctor_appointment_accepted_view.dart';

import 'package:sample/app/Doctor/doctor_todays_session/bindings/doctor_todays_session_binding.dart';
import 'package:sample/app/Doctor/doctor_todays_session/views/doctor_todays_session_view.dart';

import 'package:sample/app/Doctor/doctor_patient_detail/bindings/doctor_patient_detail_binding.dart';
import 'package:sample/app/Doctor/doctor_patient_detail/views/doctor_patient_detail_view.dart';

import 'package:sample/app/Doctor/doctor_patient_reschedule/bindings/doctor_patient_reschedule_binding.dart';
import 'package:sample/app/Doctor/doctor_patient_reschedule/views/doctor_patient_reschedule_view.dart';

import 'package:sample/app/Doctor/doctor_patient_reschedule_sent/views/doctor_patient_reschedule_sent_view.dart';

import 'package:sample/app/Doctor/doctor_cancel_session/bindings/doctor_cancel_session_binding.dart';
import 'package:sample/app/Doctor/doctor_cancel_session/views/doctor_cancel_session_view.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),

    GetPage(
      name: Routes.VERIFY_MOBILE,
      page: () => const VerifyMobileView(),
      binding: VerifyMobileBinding(),
    ),

    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: Routes.SHORTS_REELS,
      page: () => const HealthShortsPage(),
      binding: DashboardBinding(),
    ),

    // ✅ PATIENT → IDENTITY & VITALS
    GetPage(
      name: Routes.PATIENT_IDENTITY_VITALS,
      page: () => const IdentityVitalsView(),
      binding: IdentityVitalsBinding(),
    ),

    GetPage(
      name: Routes.PATIENT_MEDICAL_HISTORY,
      page: () => const MedicalHistoryView(),
      binding: MedicalHistoryBinding(),
    ),

    GetPage(
      name: Routes.PATIENT_LIFESTYLE,
      page: () => const LifestyleView(),
      binding: LifestyleBinding(),
    ),

    GetPage(
      name: Routes.PATIENT_FAMILY_WELLBEING,
      page: () => const FamilyWellbeingView(),
      binding: FamilyWellbeingBinding(),
    ),

    GetPage(
      name: Routes.PATIENT_WOMENS_HEALTH,
      page: () => const WomensHealthView(),
      binding: WomensHealthBinding(),
    ),

    GetPage(
      name: Routes.PATIENT_COMPLETION,
      page: () => const CompletionView(),
      binding: CompletionBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_EXPERIENCE,
      page: () => const ExperienceView(),
      binding: ExperienceBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_DIGITAL_READINESS,
      page: () => const DigitalReadinessView(),
      binding: DigitalReadinessBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_REGISTRATION_EDIT,
      page: () => const RegistrationEditView(),
      binding: RegistrationEditBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_EXPERIENCE_EDIT,
      page: () => const ExperienceEditView(),
      binding: ExperienceEditBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_DIGITAL_READINESS_EDIT,
      page: () => const DigitalReadinessEditView(),
      binding: DigitalReadinessEditBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_EDIT_MYPROFILE,
      page: () => const DoctorEditMyProfileView(),
      binding: DoctorEditMyProfileBinding(),
    ),

    GetPage(
      name: Routes.DOCTOR_FINAL_VERIFICATION,
      page: () => const FinalVerificationView(),
      binding: FinalVerificationBinding(),
    ),

    // Counsellors
    GetPage(
      name: Routes.COUNSELLOR_COACHES,
      page: () => const CounsellorCoachesView(),
      binding: CounsellorCoachesBinding(),
    ),

    GetPage(
      name: Routes.SELECT_COUNSELLOR,
      page: () => const SelectCounsellorView(),
      binding: SelectCounsellorBinding(),
    ),

    GetPage(
      name: '/ascvd-info',
      page: () => const AscvdInfoView(),
      binding: AscvdBinding(),
    ),
    GetPage(
      name: '/ascvd-form',
      page: () => const AscvdFormView(),
      binding: AscvdBinding(),
    ),
    GetPage(
      name: '/ascvd-result',
      page: () => const AscvdResultView(),
      binding: AscvdBinding(),
    ),

    GetPage(
      name: '/qrisk-info',
      page: () => const Qrisk3InfoView(),
      binding: Qrisk3Binding(),
    ),
    GetPage(
      name: '/qrisk3-form',
      page: () => const Qrisk3FormView(),
      binding: Qrisk3Binding(),
    ),
    GetPage(
      name: '/qrisk3-result',
      page: () => const Qrisk3ResultView(),
      binding: Qrisk3Binding(),
    ),

    GetPage(
      name: Routes.COUNSELLOR_PROFILE_DETAILS,
      page: () => const CounsellorProfileDetailsView(),
      binding: CounsellorProfileDetailsBinding(),
    ),

    // Doctor Consult
    GetPage(
      name: Routes.DOCTOR_CONSULT,
      page: () => const DoctorConsultView(),
      binding: DoctorConsultBinding(),
    ),

    GetPage(
      name: Routes.SELECT_DOCTOR,
      page: () => const SelectDoctorView(),
      binding: SelectDoctorBinding(),
    ),

    GetPage(
      name: Routes.PROFILE_DETAILS,
      page: () => const ProfileDetailsView(),
      binding: ProfileDetailsBinding(),
    ),

    GetPage(
      name: Routes.ALL_SLOTS,
      page: () => const AllSlotsView(),
      binding: AllSlotsBinding(),
    ),

    GetPage(
      name: Routes.PATIENT_DETAILS,
      page: () => const PatientDetailsView(),
      binding: PatientDetailsBinding(),
    ),

    GetPage(
      name: Routes.BOOKING_CONFIRMATION,
      page: () => const BookingConfirmationView(),
      binding: BookingConfirmationBinding(),
    ),

    GetPage(
      name: Routes.APPOINTMENT_CONFIRMED,
      page: () => const AppointmentConfirmedView(),
      // binding: BookingConfirmationBinding(),
    ),

    GetPage(
      name: '/doctor-visits',
      page: () => const DoctorVisitsView(),
      binding: DoctorVisitsBinding(),
    ),

    GetPage(
      name: '/visit-details',
      page: () => const VisitDetailsView(),
      binding: VisitDetailsBinding(),
    ),

    GetPage(
      name: '/medical-records',
      page: () => const MedicalRecordsView(),
      binding: MedicalRecordsBinding(),
    ),

    GetPage(
      name: '/save-report',
      page: () => SaveReportView(),
      binding: SaveReportBinding(),
    ),

    GetPage(
      name: '/savings-offers',
      page: () => SavingsOffersView(),
      binding: SavingsOffersBinding(),
    ),

    GetPage(
      name: '/my-profile',
      page: () => const MyProfileView(),
      binding: MyProfileBinding(),
    ),

    GetPage(
      name: '/edit-profile',
      page: () => const EditProfileSectionsView(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: '/all-reviews',
      page: () => const AllReviewsView(),
    ),

    GetPage(
      name: '/identity-vitals-edit',
      page: () => const IdentityVitalsEditView(),
      binding: IdentityVitalsEditBinding(),
    ),

    GetPage(
      name: '/medical-history-edit',
      page: () => const MedicalHistoryEditView(),
      binding: MedicalHistoryEditBinding(),
    ),

    GetPage(
      name: '/lifestyle-edit',
      page: () => const LifestyleEditView(),
      binding: LifestyleEditBinding(),
    ),

    GetPage(
      name: '/family-wellbeing-edit',
      page: () => const FamilyWellbeingEditView(),
      binding: FamilyWellbeingEditBinding(),
    ),

    GetPage(
      name: '/health-tools',
      page: () => HealthToolsView(),
    ),

    GetPage(
        name: '/wallet',
        page: () => const WalletView(),
        binding: WalletBinding()),

    GetPage(
        name: '/add-money',
        page: () => const AddMoneyView(),
        binding: AddMoneyBinding()),

    GetPage(
        name: '/transaction-history',
        page: () => const TransactionHistoryView(),
        binding: TransactionHistoryBinding()),

    GetPage(
        name: '/cancer-ai-scan',
        page: () => const CancerRiskView(),
        binding: CancerRiskBinding()),

    GetPage(
        name: '/cancer-risk-area',
        page: () => const CancerRiskAreaView(),
        binding: CancerRiskAreaBinding()),

    GetPage(
        name: '/cancer-lung-assessment',
        page: () => const CancerLungAssessmentView(),
        binding: CancerLungAssessmentBinding()),

    GetPage(
        name: '/face-scan',
        page: () => const FaceScanView(),
        binding: FaceScanBinding()),

    GetPage(
        name: '/scan-report',
        page: () => const ScanReportView(),
        binding: ScanReportBinding()),

    GetPage(
        name: '/emergency-contacts',
        page: () => const EmergencyContactsView(),
        binding: EmergencyContactsBinding()),
    GetPage(
        name: '/app-language',
        page: () => const AppLanguageView(),
        binding: AppLanguageBinding()),

    GetPage(
        name: '/fitness-tracker',
        page: () => const FitnessTrackerView(),
        binding: FitnessTrackerBinding()),

    GetPage(name: '/bmi', page: () => const BmiView(), binding: BmiBinding()),

    GetPage(
        name: '/bmi-result',
        page: () => const BmiResultView(),
        binding: BmiResultBinding()),

    GetPage(
        name: '/cancer-result',
        page: () => const CancerResultView(),
        binding: CancerResultBinding()),
    GetPage(
        name: '/find-hospital',
        page: () => const FindHospitalView(),
        binding: FindHospitalBinding()),

    GetPage(
        name: '/hospital-details',
        page: () => const HospitalDetailsView(),
        binding: HospitalDetailsBinding()),

    GetPage(
        name: '/add-medicine',
        page: () => const AddMedicineView(),
        binding: AddMedicineBinding()),
    GetPage(
        name: '/set-schedule',
        page: () => const SetScheduleView(),
        binding: SetScheduleBinding()),
    GetPage(
        name: '/medicine-reminder',
        page: () => const MedicineReminderView(),
        binding: MedicineReminderBinding()),

    GetPage(
        name: '/ai-nutritionist',
        page: () => const AiNutritionistView(),
        binding: AiNutritionistBinding()),

    GetPage(
      name: '/ai-nutritionist-result',
      page: () => const AiNutritionistResultView(),
      binding: AiNutritionistResultBinding(),
    ),

    GetPage(
        name: '/lab-tests',
        page: () => const LabTestsView(),
        binding: LabTestsBinding()),
    GetPage(
        name: '/labs-near-you',
        page: () => const LabsNearYouView(),
        binding: LabsNearYouBinding()),
    GetPage(
        name: '/lab-details',
        page: () => const LabDetailsView(),
        binding: LabDetailsBinding()),

    GetPage(
        name: '/doctor-dashboard',
        page: () => const DoctorDashboardView(),
        binding: DoctorDashboardBinding()),

    GetPage(
        name: '/doctor-notifications',
        page: () => const DoctorNotificationView(),
        binding: DoctorNotificationBinding()),

    GetPage(
        name: '/doctor-profile',
        page: () => const DoctorProfileView(),
        binding: DoctorProfileBinding()),

    GetPage(
        name: '/doctor-earnings',
        page: () => const DoctorEarningsView(),
        binding: DoctorEarningsBinding()),

    GetPage(
        name: '/doctor-reviews',
        page: () => const DoctorReviewsView(),
        binding: DoctorReviewsBinding()),

    GetPage(
        name: '/doctor-availability',
        page: () => const DoctorAvailabilityView(),
        binding: DoctorAvailabilityBinding()),

    GetPage(
        name: '/doctor-edit-schedule',
        page: () => const DoctorEditScheduleView(),
        binding: DoctorEditScheduleBinding()),

    GetPage(
        name: '/doctor-requests',
        page: () => const DoctorRequestsView(),
        binding: DoctorRequestsBinding()),

    GetPage(
        name: '/doctor-accept-booking',
        page: () => const DoctorAcceptBookingView(),
        binding: DoctorAcceptBookingBinding()),

    GetPage(
        name: '/doctor-appointment-accepted',
        page: () => const DoctorAppointmentAcceptedView(),
        binding: DoctorAppointmentAcceptedBinding()),

    GetPage(
        name: '/doctor-todays-session',
        page: () => const DoctorTodaysSessionView(),
        binding: DoctorTodaysSessionBinding()),

    GetPage(
        name: '/doctor-patient-detail',
        page: () => const DoctorPatientDetailView(),
        binding: DoctorPatientDetailBinding()),

    GetPage(
        name: '/doctor-patient-reschedule',
        page: () => const DoctorPatientRescheduleView(),
        binding: DoctorPatientRescheduleBinding()),

    GetPage(
        name: '/doctor-patient-reschedule-sent',
        page: () => const DoctorPatientRescheduleSentView()),

    GetPage(
        name: '/doctor-cancel-session',
        page: () => const DoctorCancelSessionView(),
        binding: DoctorCancelSessionBinding()),
    GetPage(
        name: '/family-members',
        page: () => const FamilyMembersView(),
        binding: FamilyMembersBinding()),
    GetPage(
        name: '/add-family-member',
        page: () => const AddFamilyMemberView(),
        binding: AddFamilyMemberBinding()),

    GetPage(
        name: '/doctor-edit-clinic',
        page: () => const DoctorEditClinicView(),
        binding: DoctorEditClinicBinding()),

    GetPage(
        name: '/scan-select-profile',
        page: () => const ScanSelectProfileView(),
        binding: ScanSelectProfileBinding()),
    GetPage(
        name: '/pre-scan-questions',
        page: () => const PreScanQuestionsView(),
        binding: PreScanQuestionsBinding()),

    GetPage(
        name: '/cancer-throat-assessment',
        page: () => const CancerthroatAssessmentView(),
        binding: CancerthroatAssessmentBinding()),
    GetPage(
        name: '/cancer-stomach-assessment',
        page: () => const CancerstomachAssessmentView(),
        binding: CancerstomachAssessmentBinding()),
    GetPage(
        name: '/cancer-skin-assessment',
        page: () => const CancerskinAssessmentView(),
        binding: CancerskinAssessmentBinding()),
    GetPage(
        name: '/cancer-general-assessment',
        page: () => const CancergeneralAssessmentView(),
        binding: CancergeneralAssessmentBinding()),
    GetPage(
        name: '/cancer-other-assessment',
        page: () => const CancerotherAssessmentView(),
        binding: CancerotherAssessmentBinding()),
    GetPage(
        name: '/select-facility-type',
        page: () => const SelectFacilityTypeView(),
        binding: SelectFacilityTypeBinding()),
    GetPage(
        name: '/basic-info',
        page: () => const BasicInfoView(),
        binding: BasicInfoBinding()),
    GetPage(
        name: '/capabilities',
        page: () => const CapabilitiesView(),
        binding: CapabilitiesBinding()),
    GetPage(
        name: '/operation-tech',
        page: () => const OperationTechView(),
        binding: OperationTechBinding()),
    GetPage(
        name: '/verification-details',
        page: () => const VerificationDetailsView(),
        binding: VerificationDetailsBinding()),
    GetPage(
        name: '/pharmacy-registration',
        page: () => const PharmacyRegistrationView(),
        binding: PharmacyRegistrationBinding()),
    GetPage(
        name: '/inventory-offerings',
        page: () => const InventoryOfferingsView(),
        binding: InventoryOfferingsBinding()),
    GetPage(
        name: '/logistics-integration',
        page: () => const LogisticsIntegrationView(),
        binding: LogisticsIntegrationBinding()),
    GetPage(
        name: '/legal-compliance',
        page: () => const LegalComplianceView(),
        binding: LegalComplianceBinding()),
    GetPage(
        name: '/basic-information',
        page: () => const BasicInformationView(),
        binding: BasicInformationBinding()),
    GetPage(
        name: '/clinical-capacity',
        page: () => const ClinicalCapacityView(),
        binding: ClinicalCapacityBinding()),
    GetPage(
        name: '/resource-allocation',
        page: () => const ResourceAllocationView(),
        binding: ResourceAllocationBinding()),
    GetPage(
        name: '/hospital-legal-compliance',
        page: () => const HospitalLegalComplianceView(),
        binding: HospitalLegalComplianceBinding()),
    GetPage(
        name: '/clinic-registration',
        page: () => const ClinicRegistrationView(),
        binding: ClinicRegistrationBinding()),
    GetPage(
        name: '/clinic-expertise',
        page: () => const ClinicExpertiseView(),
        binding: ClinicExpertiseBinding()),
    GetPage(
        name: '/operation-appointment',
        page: () => const OperationsAppointmentsView(),
        binding: OperationsAppointmentsBinding()),
    GetPage(
        name: '/clinic-legal-compliance',
        page: () => const ClinicLegalComplianceView(),
        binding: ClinicLegalComplianceBinding()),
    GetPage(
        name: '/corporate-step1',
        page: () => const CorporateStep1View(),
        binding: CorporateStep1Binding()),
    GetPage(
        name: '/corporate-step2',
        page: () => const CorporateStep2View(),
        binding: CorporateStep2Binding()),
    GetPage(
        name: '/corporate-step3',
        page: () => const CorporateStep3View(),
        binding: CorporateStep3Binding()),
    GetPage(
        name: '/corporate-step4',
        page: () => const CorporateStep4View(),
        binding: CorporateStep4Binding()),
    GetPage(
        name: '/coach-step1',
        page: () => const CoachStep1View(),
        binding: CoachStep1Binding()),
    GetPage(
        name: '/coach-step2',
        page: () => const CoachStep2View(),
        binding: CoachStep2Binding()),
    GetPage(
        name: '/coach-step3',
        page: () => const CoachStep3View(),
        binding: CoachStep3Binding()),
    GetPage(
        name: '/coach-step4',
        page: () => const CoachStep4View(),
        binding: CoachStep4Binding()),
    GetPage(
        name: '/coach-step5',
        page: () => const CoachStep5View(),
        binding: CoachStep5Binding()),
    GetPage(
        name: '/coach-step6',
        page: () => const CoachStep6View(),
        binding: CoachStep6Binding()),

    GetPage(
      name: '/see-all-appointments',
      page: () => const SeeAllAppointmentsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SeeAllAppointmentsController());
      }),
    ),
  ];
}
