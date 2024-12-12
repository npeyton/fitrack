import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  late User? _firebaseUser;
  final _auth = FirebaseAuth.instance;


  User? get firebaseUser => _firebaseUser;

  String? get userEmail => _firebaseUser!.email;

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((credentials) {
      _firebaseUser = _auth.currentUser;
      sendVerificationEmail(email, password);
    }).onError((FirebaseException error, stackTrace) {
      throw error.message!;
    });
  }


  Future<void> sendVerificationEmail(String email, String password) async {
    try {
      if (_auth.currentUser != null &&
          _auth.currentUser!.email == email.toLowerCase()) {
        _auth.currentUser!.sendEmailVerification().onError((error, stackTrace) {
          debugPrint(error.toString());
        });
      } else if (_auth.currentUser != null &&
          _auth.currentUser!.email != email) {
        await _auth.signOut();
        _firebaseUser = null;
        sendVerificationEmail(email, password);
      } else {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        _firebaseUser = _auth.currentUser!;
        sendVerificationEmail(email, password);
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> resendVerificationEmail() async {
    _auth.currentUser!.sendEmailVerification().catchError((error, stackTrace) {
      throw error!;
    }).onError((error, stackTrace) => throw error!);
  }

  Future<void> signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => debugPrint(value.toString()))
        .onError((FirebaseAuthException error, stackTrace) {
      throw error.message.toString();
    });
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .onError((FirebaseException e, stackTrace) {
        throw e.message.toString();
      });
      _firebaseUser = null;
    } catch (e) {
      rethrow;
    }
  }

  bool isLoggedIn() {
    if (_auth.currentUser != null) {
      _firebaseUser = _auth.currentUser;
      return true;
    } else {
      return false;
    }
  }

  bool isVerified() {
    if (_auth.currentUser!.emailVerified) {
      _firebaseUser = _auth.currentUser;
      return true;
    } else {
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      debugPrint("sent ");
    }).onError((FirebaseException error, stackTrace) {
      throw error.message!;
    });
  }

}
