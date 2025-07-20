// lib/app/routes/app_routes.dart
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SIGNIN = _Paths.SIGNIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const FORGET_PASSWORD = _Paths.FORGET_PASSWORD;
  static const SPLASH = _Paths.SPLASH; // Add splash route
  static const QUIZ_LIST = _Paths.QUIZ_LIST;
  static const QUIZ_SCREEN = _Paths.QUIZ_SCREEN;
  static const RESULT_SCREEN = _Paths.RESULT_SCREEN;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SIGNIN = '/signin';
  static const SIGNUP = '/signup';
  static const FORGET_PASSWORD = '/forget-password';
  static const SPLASH = '/'; // Set splash as the root path
  static const QUIZ_LIST = '/quiz-list';
  static const QUIZ_SCREEN = '/quiz-screen';
  static const RESULT_SCREEN = '/result-screen';
}
