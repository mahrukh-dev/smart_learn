// lib/app/modules/home/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:smart_learn/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
