import 'package:get/get.dart';
import '../controllers/ai_nutritionist_result_controller.dart';

class AiNutritionistResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiNutritionistResultController>(
        () => AiNutritionistResultController());
  }
}
