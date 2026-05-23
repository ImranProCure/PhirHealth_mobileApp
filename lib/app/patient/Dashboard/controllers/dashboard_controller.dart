import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';

class DashboardController extends GetxController {
  final RxInt selectedNavIndex = 0.obs;

  void selectNav(int index) {
    selectedNavIndex.value = index;
    if (index == 1) Get.toNamed('/doctor-visits');
    if (index == 3) showMessage("Coming Soon");
    //Get.toNamed('/shorts-reels');
    if (index == 4) Get.toNamed('/my-profile');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFcmToken();
  }

  Future<void> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();

      print("FCM Token: $token");
    } else {
      print("Notification permission denied");
    }
  }

  // ===== DOCTOR ACTIONS =====
  final List<Map<String, String>> doctorActions = [
    {
      'icon': 'assets/icons/stethoscope1.png',
      'label': 'patient_dash_action_consult'
    },
    {'icon': 'assets/icons/ar_on_you.png', 'label': 'patient_dash_action_scan'},
    {
      'icon': 'assets/icons/health_cross.png',
      'label': 'patient_dash_action_locator'
    },
    {
      'icon': 'assets/icons/health_and_safety.png',
      'label': 'patient_dash_action_counsellor'
    },
    {
      'icon': 'assets/icons/lab_research.png',
      'label': 'patient_dash_action_lab'
    },
    {
      'icon': 'assets/icons/supervisor_account.png',
      'label': 'patient_dash_action_insurance'
    },
  ];

  void onDoctorActionTap(int index) {
    if (index == 0) Get.toNamed('/doctor-consult');
    if (index == 1) showMessage("Coming soon");
    //Get.toNamed('/scan-select-profile');
    if (index == 2) showMessage("Coming soon");
    //Get.toNamed('/find-hospital');
    if (index == 3) Get.toNamed('/counsellor-consult');
    if (index == 4) showMessage("Coming soon");
    //Get.toNamed('/lab-tests');
  }

  // ===== SMART HEALTH TOOLS =====
  final List<Map<String, dynamic>> smartTools = [
    {
      'title': 'patient_dash_bmi',
      'icon': 'assets/icons/bmi 1.png',
      'route': '/bmi'
    },
    {
      'title': 'patient_dash_diet',
      'icon': 'assets/icons/salad 1.png',
      'route': '/ai-nutritionist'
    },
    {
      'title': 'patient_dash_reminder',
      'icon': 'assets/icons/time 1.png',
      'route': '/add-medicine'
    },
  ];

  final List<Map<String, dynamic>> healthTools = [
    {
      'title': 'ASCVD\nHeart Disease',
      'icon': 'assets/Group 177.png',
      'route': '/ascvd-info'
    },
    {
      'title': 'QRISK3\nHeart Risk',
      'icon': 'assets/Group 177.png',
      'route': '/qrisk-info'
    },
  ];

  void onSmartToolTap(int index) {
    final route = smartTools[index]['route'] as String;
    Get.toNamed(route);
  }

  void onHealthToolTap(int index) {
    final route = healthTools[index]['route'] as String;
    if (healthTools[index]['title'] == "patient_dash_diet") {
      showMessage("Comng soon");
    } else {
      Get.toNamed(route);
    }
  }

  // ===== AI + MEDICINE + FITNESS =====
  void goToSavingsOffers() => showMessage("Coming soon");
  //Get.toNamed('/savings-offers');
  void goToFitnessTracker() => showMessage("Coming soon");
  //Get.toNamed('/fitness-tracker');
  void goToCancerAiScan() => showMessage("Coming soon");
  //Get.toNamed('/cancer-ai-scan');
}
