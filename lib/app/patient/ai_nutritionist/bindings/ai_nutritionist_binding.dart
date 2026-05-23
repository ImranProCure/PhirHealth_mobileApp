import 'package:get/get.dart';
import '../controllers/ai_nutritionist_controller.dart';
import '../../ai_nutritionist_result/controllers/ai_nutritionist_result_controller.dart';

class AiNutritionistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiNutritionistController>(
      () => AiNutritionistController(),
    );
    Get.lazyPut<AiNutritionistResultController>(
      () => AiNutritionistResultController(),
    );
  }
}
