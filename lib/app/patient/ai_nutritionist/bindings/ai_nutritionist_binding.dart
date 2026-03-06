import 'package:get/get.dart';
import '../controllers/ai_nutritionist_controller.dart';

class AiNutritionistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiNutritionistController>(() => AiNutritionistController());
  }
}
