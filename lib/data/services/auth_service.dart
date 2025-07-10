import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:smart_learn/core/utils/app_dialogs.dart';
import 'package:smart_learn/data/models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Observable for authenticated user
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get firebaseUser => _firebaseUser.value;

  // Observable for custom user model
  final Rx<UserModel?> _appUser = Rx<UserModel?>(null);
  UserModel? get appUser => _appUser.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize google_sign_in singleton
    _googleSignIn.initialize();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    // This is the crucial part that redirects the user from the splash screen
    if (user == null) {
      Get.offAllNamed('/signin'); // Go to sign-in if no user
      _appUser.value = null;
    } else {
      // If a user exists, fetch user data and navigate to home
      await _fetchAppUser(user.uid);
      Get.offAllNamed('/home');
    }
  }

  Future<void> _fetchAppUser(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        _appUser.value = UserModel.fromDocumentSnapshot(userDoc);
      } else {
        _appUser.value = UserModel(
          uid: uid,
          name: _firebaseUser.value?.displayName ?? 'New User',
        );
        await _firestore
            .collection('Users')
            .doc(uid)
            .set(_appUser.value!.toJson());
      }
    } catch (e) {
      AppDialogs.showFlushbar(
        'Error',
        'Failed to load user data: $e',
        isError: true,
      );
      _appUser.value = null;
    }
  }

  Future<void> signUpWithEmailPassword(
      String email, String password, String name) async {
    AppDialogs.showLoading();
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        _appUser.value = UserModel(uid: user.uid, name: name);
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .set(_appUser.value!.toJson());
        AppDialogs.dismissLoading();
        AppDialogs.showFlushbar(
          'Success',
          'Account created successfully! Please sign in.',
        );
        Get.offAllNamed('/signin');
      }
    } on FirebaseAuthException catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Sign Up Failed',
        e.message ?? 'An unknown error occurred.',
        isError: true,
      );
    } catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Error',
        'An unexpected error occurred: $e',
        isError: true,
      );
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    AppDialogs.showLoading();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _fetchAppUser(userCredential.user!.uid);
        AppDialogs.dismissLoading();
        AppDialogs.showFlushbar(
          'Success',
          'Welcome back, ${_appUser.value?.name ?? 'User'}!',
        );
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Sign In Failed',
        e.message ?? 'Invalid credentials.',
        isError: true,
      );
    } catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Error',
        'An unexpected error occurred: $e',
        isError: true,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    AppDialogs.showLoading();
    try {
      // Initialize Google Sign-In with client IDs
      await GoogleSignIn.instance.initialize(
        clientId:
            '755505103647-8fk1p9g4b17tapte51itl2t4ick1esqh.apps.googleusercontent.com', // Android client ID
        serverClientId:
            '755505103647-jsnlenlpcm1aip2in6pqtlo524nu5ki2.apps.googleusercontent.com',
      );

      // Attempt authentication
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        AppDialogs.dismissLoading();
        AppDialogs.showFlushbar(
          'Error',
          'Authentication failed or was cancelled.',
          isError: true,
        );
        return;
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential from the access token
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        AppDialogs.dismissLoading();
        AppDialogs.showFlushbar(
          'Error',
          'Firebase authentication failed.',
          isError: true,
        );
        return;
      }

      await _fetchAppUser(user.uid);

      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Success',
        'Welcome, ${_appUser.value?.name ?? 'User'}!',
      );
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Google Sign In Failed',
        e.message ?? 'An error occurred during Google Sign-In.',
        isError: true,
      );
    } on GoogleSignInException catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Google Sign In Failed',
        _errorMessageFromSignInException(e),
        isError: true,
      );
    } catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Error',
        'An unexpected error occurred: $e',
        isError: true,
      );
    }
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }

  Future<void> sendPasswordResetEmail(String email) async {
    AppDialogs.showLoading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Password Reset Email Sent',
        'A password reset link has been sent to $email. Please check your inbox.',
      );
      Get.back();
    } on FirebaseAuthException catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Password Reset Failed',
        e.message ?? 'An error occurred.',
        isError: true,
      );
    } catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Error',
        'An unexpected error occurred: $e',
        isError: true,
      );
    }
  }

  Future<void> signOut() async {
    AppDialogs.showLoading();
    try {
      await _auth.signOut();
      await _googleSignIn.disconnect();
      _appUser.value = null;
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Signed Out',
        'You have been successfully signed out.',
      );
      Get.offAllNamed('/signin');
    } catch (e) {
      AppDialogs.dismissLoading();
      AppDialogs.showFlushbar(
        'Sign Out Failed',
        'An error occurred during sign out: $e',
        isError: true,
      );
    }
  }
}
