import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/controllers/role_controller.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  Get.put(RoleController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F5F5)),

      // ✅ App start point (Splash se)
      initialRoute: Routes.SPLASH,

      // ✅ All app routes in one place
      getPages: AppPages.routes,
    );
  }
}
