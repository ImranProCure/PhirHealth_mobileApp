import 'package:get/get.dart';

// app/modules
import '../modules/splash/views/splash_view.dart';

import '../modules/verify_mobile/views/verify_mobile_view.dart';
import '../modules/verify_mobile/bindings/verify_mobile_binding.dart';

import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';

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
  ];
}
