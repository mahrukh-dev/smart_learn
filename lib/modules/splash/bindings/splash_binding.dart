// lib/app/modules/splash/bindings/splash_binding.dart
import 'package:get/get.dart';
import 'package:smart_learn/modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
