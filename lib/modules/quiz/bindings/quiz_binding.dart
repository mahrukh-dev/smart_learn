import 'package:get/get.dart';
import 'package:smart_learn/data/services/quiz_service.dart';
import 'package:smart_learn/modules/quiz/controllers/quiz_controller.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QuizService>(QuizService());
    Get.lazyPut<QuizController>(
      () => QuizController(),
    );
  }
}
