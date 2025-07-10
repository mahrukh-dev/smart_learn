import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smart_learn/core/theme/app_theme.dart';
import 'package:smart_learn/data/services/auth_service.dart';
import 'package:smart_learn/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize AuthService as a permanent dependency as soon as the app starts
    Get.put<AuthService>(AuthService(), permanent: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SmartLearn',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme, // Initial theme
      darkTheme: AppTheme.darkTheme, // Dark theme
      themeMode: ThemeMode.system,
    );
  }
}
