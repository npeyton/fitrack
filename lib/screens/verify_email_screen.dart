
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../custom_widgets/button.dart';
import '../config/constants.dart';
import '../controllers/app_controller.dart';
import '../controllers/auth_controller.dart';
import '../custom_widgets/snackbar_messenger.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailScreen> {

  late final AuthController authController;
  late final AppController appController;

  final CountdownController _controller = CountdownController(autoStart: true);
  bool _canResend = false;

  @override
  void initState() {
    authController = context.read<AuthController>();
    appController = context.read<AppController>();
    authController.startListeningToVerificationUpdates();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: authController,
            builder: (BuildContext context, Widget? child) {
              switch (authController.isUserVerified) {
                case true:
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                              height: 180,
                              child: Image.asset(
                                "assets/images/bottle.png",
                                fit: BoxFit.fitHeight,
                              )),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verified!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const Text(
                          "Yahoo! You have successfully verified the account",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: CustomButton(
                            title: "Continue",
                            onClick: () {
                              appController.initialize();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                case false:
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        FractionallySizedBox(
                            widthFactor: .4,
                            child:
                                Image.asset("assets/images/notification.png")),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, top: 20, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Verify your email",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, right: 20.0),
                          child: Text(
                            "Please check your email for the verification link at ${authController.authRepository.firebaseUser!.email!}",
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Countdown(
                          controller: _controller,
                          seconds: 60,
                          build: (_, double time) => Text(
                            time.round().toString(),
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                          interval: const Duration(milliseconds: 100),
                          onFinished: () {
                            setState(() {
                              _canResend = true;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (_canResend) {
                                    try {
                                      await authController.resendLink();
                                      if (context.mounted) {
                                        SnackBarMessenger.of(context)
                                            .showSuccess(
                                                "Link sent successfully.");
                                      }
                                      setState(() => _canResend = false);
                                      _controller.onRestart!();
                                    } catch (e) {
                                      if (context.mounted) {
                                        SnackBarMessenger.of(context)
                                            .showDanger(e.toString());
                                      }
                                    }
                                  } else {
                                    SnackBarMessenger.of(context).showWarning(
                                        "Please wait for the timer to complete to resend link.");
                                  }
                                },
                                child: _canResend
                                    ? Text(
                                        "Resend Link",
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: theme.primaryColorDark,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kHorizontalSpacing),
                          child: Text(
                            "(No verification email? Please check Spam or Trash)",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            appController.logout();
                            //context.goNamed("auth");
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kHorizontalSpacing),
                              child: Text(
                                maxLines: 3,
                                "Wrong email?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: theme.primaryColorDark,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        const SafeArea(child: SizedBox()),
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
