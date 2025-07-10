import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppDialogs {
  static void showLoading() {
    Get.dialog(
      const PopScope(
        canPop: false,
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.deepPurple,
            size: 50.0,
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void dismissLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static void showFlushbar(String title, String message,
      {bool isError = false}) {
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        size: 28.0,
        color: isError ? Colors.red.shade300 : Colors.green.shade300,
      ),
      leftBarIndicatorColor:
          isError ? Colors.red.shade300 : Colors.green.shade300,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
      backgroundColor: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
      titleColor: Get.isDarkMode ? Colors.white : Colors.black,
      messageColor: Get.isDarkMode ? Colors.white70 : Colors.black87,
    ).show(Get.context!);
  }
}
