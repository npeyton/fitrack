import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fittrack/models/user_model.dart' as local;
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  bool isUserVerified = false;
  User? _firebaseUser;
  bool _isInitialized = false;
  final AuthRepository authRepository;

  User? get user => _firebaseUser;


  AuthController({ required this.authRepository});

  Future<void> createUser(local.User user) async {
    try {
      await authRepository.createUserWithEmailAndPassword(
          email: user.email, password: user.password!);
      _firebaseUser = FirebaseAuth.instance.currentUser!;
    } catch (e) {
      debugPrint("AuthController :  ${e.toString()}");
      rethrow;
    }
  }


  void startListeningToVerificationUpdates() {
    //TODO Replace timer with builtin onVerified
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser == null) {
        timer.cancel();
      }
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        timer.cancel();
        isUserVerified = true;
        notifyListeners();
      }
    });
  }


  Future<void> resendLink() async {
    try {
      await authRepository.resendVerificationEmail();
    } catch (e) {
      rethrow;
    }
  }

  bool isAlreadyLoggedIn() {
    if (authRepository.isLoggedIn()) {
      _firebaseUser = FirebaseAuth.instance.currentUser!;
      debugPrint(_firebaseUser!.displayName);
    }
    return authRepository.isLoggedIn();
  }

  bool isVerified() {
    _firebaseUser!.reload();
    isUserVerified = _firebaseUser!.emailVerified;
    return isUserVerified;
  }

  String getEmail() {
    return authRepository.firebaseUser!.email!;
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      _firebaseUser = null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await authRepository.signIn(email, password);
      _firebaseUser = FirebaseAuth.instance.currentUser!;
      debugPrint(_firebaseUser!.email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await authRepository.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }


}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
