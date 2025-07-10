import 'package:get/get.dart';
import 'package:smart_learn/data/services/auth_service.dart';
import 'package:smart_learn/modules/auth/controllers/forget_password_controller.dart';
import 'package:smart_learn/modules/auth/controllers/signin_controller.dart';
import 'package:smart_learn/modules/auth/controllers/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(),
        permanent: true); // Make AuthService persistent
    Get.lazyPut<SigninController>(
      () => SigninController(),
    );
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
  }
}
