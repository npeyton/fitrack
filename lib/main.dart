import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/screens/add_graph.dart';
import 'package:fittrack/screens/create_day.dart';
import 'package:fittrack/screens/create_exercise.dart';
import 'package:fittrack/screens/create_routine_screen.dart';
import 'package:fittrack/screens/exercise_screen.dart';
import 'package:fittrack/screens/home_screen.dart';
import 'package:fittrack/screens/log_day.dart';
import 'package:fittrack/screens/routines_screen.dart';
import 'package:fittrack/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app_init.dart';
import 'config/colors.dart';
import 'config/firebase_options.dart';
import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/exercise_controller.dart';
import 'custom_widgets/snackbar_messenger.dart';
import 'repositories/app_configuration_repository.dart';
import 'repositories/auth_repository.dart';
import 'screens/days_screen.dart';
import 'screens/create_account.dart';
import 'screens/login_screen.dart';
import 'screens/verify_email_screen.dart';
import 'screens/verify_otp _screen.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

// navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorChatKey = GlobalKey<NavigatorState>(debugLabel: 'Chat');
final _shellNavigatorMapKey = GlobalKey<NavigatorState>(debugLabel: 'Map');
final _shellNavigatorLeaderboardKey =
GlobalKey<NavigatorState>(debugLabel: 'Leaderboard');
final _shellNavigatorProfileKey =
GlobalKey<NavigatorState>(debugLabel: 'Profile');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  auth = FirebaseAuth.instanceFor(app: app);

  // FirebaseHelper.setupNotifications();
  // NotificationService.initializeNotification();
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    _authRepository = AuthRepository();
    _exerciseController = ExerciseController();
    _appConfigurationsRepository =
        AppConfigurationsRepository();
    _authController =
        AuthController(authRepository: _authRepository);

    // _profileRepository =
    //     ProfileRepository(dbClient: _dbClient, authController: _authController);

    _appController = AppController(
      router: _router,
      authController: _authController,
      appConfigurationsRepository: _appConfigurationsRepository,
    );
  }


  //Repositories
  late final AuthRepository _authRepository;
  late final AppConfigurationsRepository _appConfigurationsRepository;
  //late final ProfileRepository _profileRepository;

  //Controllers
  late final AuthController _authController;
  late final ExerciseController _exerciseController;
  late final AppController _appController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: _authRepository),
        //Provider.value(value: _profileRepository),
        ChangeNotifierProvider.value(value: _authController),
        ChangeNotifierProvider.value(value: _appController),
        ChangeNotifierProvider.value(value: _exerciseController),
        //ChangeNotifierProvider(create: (_) => NavBarController()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          primaryColorDark: AppColors.primaryDarkColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.black,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          useMaterial3: true,
        ),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          final textScaleFactor = min(
            kIsWeb
                ? mediaQuery.textScaleFactor - 0.1
                : !Platform.isIOS
                ? mediaQuery.textScaleFactor - 0.1
                : mediaQuery.textScaleFactor,
            1.1,
          );
          return ResponsiveBreakpoints.builder(
            child: MediaQuery(
              data: mediaQuery.copyWith(textScaleFactor: textScaleFactor),
              child: SnackBarMessenger(
                child: AppInit(
                  child: child ?? const SizedBox(),
                ),
              ),
            ),
            breakpoints: [
              const Breakpoint(start: 100, end: 800, name: MOBILE),
              const Breakpoint(start: 801, end: 1000, name: TABLET),
              const Breakpoint(start: 1001, end: 1200, name: TABLET),
              const Breakpoint(start: 1201, end: 2460, name: DESKTOP),
              const Breakpoint(start: 2461, end: double.infinity, name: "4K"),
            ],
          );
        },
      ),
    );
  }


  final GoRouter _router = GoRouter(
    initialLocation: "/auth",
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'auth/login',
            name: 'auth.login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
          GoRoute(
            path: 'auth/signup',
            name: 'auth.signup',
            builder: (BuildContext context, GoRouterState state) {
              return const CreateAccount();
            },
          ),
          GoRoute(
            path: 'auth/verifyOtp',
            name: 'auth.verifyOtp',
            builder: (BuildContext context, GoRouterState state) {
              return const VerifyEmailScreen();
            },
          ),
          // GoRoute(
          //   path: 'auth/forgotPassword',
          //   name: 'auth.forgotPassword',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return const ForgotPasswordScreen();
          //   },
          // ),
          GoRoute(
            path: 'auth/verifyOtpFP',
            name: 'auth.verifyOtpFP',
            builder: (BuildContext context, GoRouterState state) {
              return const VerifyOtp();
            },
          ),
          // GoRoute(
          //   path: 'auth/updatePassword',
          //   name: 'auth.updatePassword',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return const UpdatePasswordScreen();
          //   },
          // ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
          routes: <RouteBase>[
            GoRoute(
              path: 'home/addRoutine',
              name: 'home.addRoutine',
              builder: (BuildContext context, GoRouterState state) {
                return CreateRoutineScreen();
              },
            ),

            GoRoute(
              path: 'home/exercise',
              name: 'home.exercise',
              builder: (BuildContext context, GoRouterState state) {
                return const ExerciseScreen();
              },
            ),
            GoRoute(
              path: 'home/createExercise',
              name: 'home.createExercise',
              builder: (BuildContext context, GoRouterState state) {
                return CreateExercise();
              },
            ),
            GoRoute(
              path: 'home/createDay',
              name: 'home.createDay',
              builder: (BuildContext context, GoRouterState state) {
                return CreateDay();
              },
            ),
            GoRoute(
              path: 'home/addGraph',
              name: 'home.addGraph',
              builder: (BuildContext context, GoRouterState state) {
                return AddGraph();
              },
            ),
            GoRoute(
              path: 'home/routine',
              name: 'home.routine',
              builder: (BuildContext context, GoRouterState state) {
                return const RoutinesScreen();
              },
            ),
            GoRoute(
              path: 'home/logDay',
              name: 'home.logDay',
              builder: (BuildContext context, GoRouterState state) {
                return LogDay();
              },
            ),
          ]
      ),
    ],
  );
}
