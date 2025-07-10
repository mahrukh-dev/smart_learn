import 'package:get/get.dart';
import 'package:smart_learn/modules/auth/bindings/auth_binding.dart';
import 'package:smart_learn/modules/auth/views/forget_password_view.dart';
import 'package:smart_learn/modules/auth/views/signin_view.dart';
import 'package:smart_learn/modules/auth/views/signup_view.dart';
import 'package:smart_learn/modules/home/bindings/home_binding.dart';
import 'package:smart_learn/modules/home/views/home_view.dart';
import 'package:smart_learn/modules/splash/bindings/splash_binding.dart';
import 'package:smart_learn/modules/splash/views/splash_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH; // Set initial route to Sign-in

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
