import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../exceptions/unauthenticated_exception.dart';

import 'package:package_info_plus/package_info_plus.dart';
import '../models/app_configurations.dart';
import '../repositories/app_configuration_repository.dart';
import 'auth_controller.dart';

import '../models/user_model.dart' as dbUser;

class AppController extends ChangeNotifier {
  AppController({
    required this.router,
    required this.authController,
    required this.appConfigurationsRepository,
  });

  final GoRouter router;
  final AuthController authController;
  final AppConfigurationsRepository appConfigurationsRepository;

  PackageInfo? _packageInfo;

  bool _shouldForceUpdate = false;

  User? _user;

  User? get user => _user;

  late AppConfigurations _configurations;

  // used to determine first lauch
  bool _appLaunched = false;
  bool _firstLaunch = true;

  bool _newLogin = true;

  Object? _error;

  bool _isLoading = true;

  AppConfigurations get configurations => _configurations;

  bool get appLaunched => _appLaunched;

  bool get newLogin => _newLogin;

  PackageInfo? get packageInfo => _packageInfo;

  bool get shouldForceUpdate => _shouldForceUpdate;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  bool get hasError => _error != null;

  Future<void> initialize() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      if (_packageInfo == null) {
        _packageInfo = await PackageInfo.fromPlatform();
        notifyListeners();
      }

      _clearData();

      SharedPreferences pref = await SharedPreferences.getInstance();

      if (pref.containsKey("firstLaunch")) {
        _firstLaunch = pref.getBool("firstLaunch")!;
      }

      //Initialize DB client ( Create connection with DataBase )


      // Fetch app configurations
      //_configurations = (await appConfigurationsRepository.retrieve())!;

      //Check if force update required
      // if ((Platform.isIOS &&
      //         _configurations.activeIosBuildNumbers.isNotEmpty &&
      //         !_configurations.activeIosBuildNumbers
      //             .contains(_packageInfo!.buildNumber)) ||
      //     (Platform.isAndroid &&
      //         _configurations.activeAndroidBuildNumbers.isNotEmpty &&
      //         !_configurations.activeAndroidBuildNumbers
      //             .contains(_packageInfo!.buildNumber))) {
      //   _shouldForceUpdate = true;
      //   _appLaunched = true;
      //   _isLoading = false;
      //   notifyListeners();
      //   return;
      // }


      // Check if previously logged in
      if (authController.isAlreadyLoggedIn()) {
        _newLogin = false;

        //Verified Users
        if (authController.isVerified()) {
          //Students

          router.goNamed("home");

        } else {
          // Not Verified
          router.goNamed("auth.verifyOtp");
        }
        _appLaunched = true;
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (_firstLaunch) {
        router.goNamed("auth.signup");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("firstLaunch", false);
        _appLaunched = true;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Not logged In
      router.goNamed("auth.login");

      _appLaunched = true;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      if (error is UnauthenticatedException) {
        router.goNamed('auth.login');
      }
      _error = error;
    }

    _isLoading = false;
    _appLaunched = true;
    notifyListeners();
  }

  void _clearData() {
    _user = null;
    _error = null;
    _shouldForceUpdate = false;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await authController.signIn(email, password);

    initialize();
  }

  Future<void> logout() async {
    await authController.signOut();
    initialize();
  }

  Future<void> createUser({required dbUser.User user}) async {
    try {
      await authController.createUser(user);
      initialize();
    } catch (e) {
      rethrow;
    }
  }


  // Future<void> updateUserName(String fn, String ln) async {
  //   try {
  //     await authController.updateUserName(fn, ln);
  //     if (_user!.role == Roles.student) {
  //       await authController.getLocalUser();
  //       _user = authController.localUser!;
  //       _studentProfile = await profileRepository.getProfile();
  //       _accountTags = await profileRepository.getAccountTags();
  //     } else {
  //       _businessProfile = await profileRepository.getBusinessProfile();
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
