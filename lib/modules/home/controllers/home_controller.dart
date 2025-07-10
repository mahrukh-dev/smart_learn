// lib/app/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:smart_learn/data/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Example of using the authenticated user data
  String? get userName => _authService.appUser?.name;

  void signOut() {
    _authService.signOut();
  }

  // TODO: Add other home screen logic here (e.g., fetching quiz topics)
}
