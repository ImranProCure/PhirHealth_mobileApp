import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'app/controllers/role_controller.dart';
import 'app/modules/translations/app_translations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

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

        // ✅ App start point
        initialRoute: Routes.SPLASH,

        // ✅ All app routes
        getPages: AppPages.routes,
      ),
    );
  }
}
