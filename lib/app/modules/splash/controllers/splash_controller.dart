import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../home/bindings/home_binding.dart';

class SplashController extends GetxController {
  bool _hasNavigated = false;

  @override
  void onReady() {
    super.onReady();

    if (_hasNavigated) return;
    _hasNavigated = true;

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
        () => const HomeView(),
        binding: HomeBinding(),
      );
    });
  }
}
