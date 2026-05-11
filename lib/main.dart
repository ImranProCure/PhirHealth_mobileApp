import 'package:get/get.dart';
import 'package:sample/app/controllers/role_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './app/model/medicine_model.dart';
import './app/service/notification_service/notification_service.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/modules/translations/app_translations.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // ── Hive init ──────────────────────────────────────────
  await Hive.initFlutter();
  Hive.registerAdapter(MedicineModelAdapter());
  Hive.registerAdapter(DoseModelAdapter());
  Hive.registerAdapter(AdherenceModelAdapter());
  await Hive.openBox<MedicineModel>('medicines');
  await Hive.openBox<AdherenceModel>('adherence');

  // ── Notification init ──────────────────────────────────
  await NotificationService.instance.init();

  Get.put(RoleController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PHIR Health',
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F5F5)),

        // ✅ Localization
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),

        // ✅ App start point (Splash se)
        initialRoute: Routes.SPLASH,

        // ✅ All app routes in one place
        getPages: AppPages.routes,
      ),
    );
  }
}
