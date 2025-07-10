// lib/app/modules/splash/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_learn/core/constants/app_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import for loading spinner

class SplashView extends GetView {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Get.theme.primaryColor,
              ),
            ),
            const SizedBox(height: 50),
            // We use flutter_spinkit here to show the user we are loading
            const SpinKitFadingCircle(
              color: Colors.deepPurple,
              size: 60.0,
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
