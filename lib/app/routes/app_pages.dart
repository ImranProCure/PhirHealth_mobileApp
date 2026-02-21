import 'package:get/get.dart';

// app/modules
import '../modules/splash/views/splash_view.dart';

import '../modules/verify_mobile/views/verify_mobile_view.dart';
import '../modules/verify_mobile/bindings/verify_mobile_binding.dart';

import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';

import 'package:sample/app/modules/doctor_consult/bindings/doctor_consult_binding.dart';
import 'package:sample/app/modules/doctor_consult/views/doctor_consult_view.dart';

// ❗ patient is OUTSIDE app folder
import '../../patient/profile_setup/identity_vitals/views/identity_vitals_view.dart';
import '../../patient/profile_setup/identity_vitals/bindings/identity_vitals_binding.dart';

import '../../patient/profile_setup/medical_history/views/medical_history_view.dart';
import '../../patient/profile_setup/medical_history/bindings/medical_history_binding.dart';

import '../../patient/profile_setup/Lifestyle/views/lifestyle_view.dart';
import '../../patient/profile_setup/Lifestyle/bindings/lifestyle_binding.dart';

import '../../patient/profile_setup/family_wellbeing/views/family_wellbeing_view.dart';
import '../../patient/profile_setup/family_wellbeing/bindings /family_wellbeing_binding.dart';

import '../../patient/profile_setup/Womens_health/views/womens_health_view.dart';
import '../../patient/profile_setup/Womens_health/bindings/womens_health_binding.dart';

import '../../patient/profile_setup/completion/views/completion_view.dart';
import '../../patient/profile_setup/completion/bindings/completion_binding.dart';

import '../../Doctor/profile_setup/registration/views/registration_view.dart';
import '../../Doctor/profile_setup/registration/bindings/registration_binding.dart';

import '../../Doctor/profile_setup/experience/views/experience_view.dart';
import '../../Doctor/profile_setup/experience/bindings/experience_binding.dart';

import '../../Doctor/profile_setup/digital_readiness/views/digital_readiness_view.dart';
import '../../Doctor/profile_setup/digital_readiness/bindings/digital_readiness_binding.dart';

import '../../Doctor/profile_setup/final_verification/views/final_verification_view.dart';
import '../../Doctor/profile_setup/final_verification/bindings/final_verification_binding.dart';

import 'package:sample/app/modules/profile_details/bindings/profile_details_binding.dart';
import 'package:sample/app/modules/profile_details/views/profile_details_view.dart';

import 'package:sample/app/modules/select_doctor/bindings/select_doctor_binding.dart';
import 'package:sample/app/modules/select_doctor/views/select_doctor_view.dart';

import 'package:sample/app/modules/all_slots/bindings/all_slots_binding.dart';
import 'package:sample/app/modules/all_slots/views/all_slots_views.dart';

import 'package:sample/app/modules/patient_details/bindings/patient_details_binding.dart';
import 'package:sample/app/modules/patient_details/views/patient_details_view.dart';

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
      name: Routes.DOCTOR_FINAL_VERIFICATION,
      page: () => const FinalVerificationView(),
      binding: FinalVerificationBinding(),
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
  ];
}
