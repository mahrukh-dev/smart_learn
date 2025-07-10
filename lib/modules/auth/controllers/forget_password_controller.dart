import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_learn/data/services/auth_service.dart';

class ForgetPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final TextEditingController emailController = TextEditingController();

  Future<void> sendResetEmail() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await _authService.sendPasswordResetEmail(email);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
