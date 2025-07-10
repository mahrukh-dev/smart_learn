// lib/app/modules/auth/controllers/signin_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_learn/data/services/auth_service.dart';

class SigninController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<void> signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await _authService.signInWithEmailPassword(email, password);
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
