// lib/app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';

// Note: We don't need to explicitly find AuthService here,
// as AuthService handles the routing in its onInit() and _setInitialScreen()
class SplashController extends GetxController {
  // This controller exists primarily to ensure the splash view is displayed
  // while AuthService initializes and determines the user state.
}
