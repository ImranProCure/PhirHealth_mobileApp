import 'package:get/get.dart';
import 'package:sample/app/controllers/role_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  if (defaultTargetPlatform == TargetPlatform.android) {
//     InAppWebViewPlatform.instance = AndroidInAppWebViewPlatform();
//   } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//     InAppWebViewPlatform.instance = IOSInAppWebViewPlatform();
//   }
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);

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

          // ✅ App start point (Splash se)
          initialRoute: Routes.SPLASH,

          // ✅ All app routes in one place
          getPages: AppPages.routes,
        ));
  }
}
