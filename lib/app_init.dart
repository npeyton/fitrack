import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_store/open_store.dart';
import 'package:provider/provider.dart';

import 'config/constants.dart';
import 'controllers/app_controller.dart';
import 'custom_widgets/button.dart';

class AppInit extends StatefulWidget {
  const AppInit({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  AppInitState createState() => AppInitState();
}

class AppInitState extends State<AppInit> {
  AppController? _appController;

  @override
  void initState() {
    _appController = context.read<AppController>();
    super.initState();

    _appController!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          theme.appBarTheme.systemOverlayStyle ?? const SystemUiOverlayStyle(),
      child: AnimatedBuilder(
        animation: _appController!,
        builder: (context, child) {
          Widget? statusWidget;
          if (_appController!.isLoading) {
            statusWidget = _buildLoading();
          } else if (_appController!.hasError) {
            statusWidget = _buildError();
          } else if (_appController!.shouldForceUpdate) {
            statusWidget = _buildForceUpdate();
          }

          return Container(
            color: theme.scaffoldBackgroundColor,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              child: statusWidget ??
                  Container(
                    key: const Key("App"),
                    child: widget.child,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    final theme = Theme.of(context);
    final child = _appController!.appLaunched
        ? const CircularProgressIndicator()
        : Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 150),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/logo.png"),
                const SizedBox(height: 30),
                const LinearProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.black12,
                ),
                if (_appController!.packageInfo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Version ${_appController!.packageInfo!.version}+${_appController!.packageInfo!.buildNumber}",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          );

    return Scaffold(
      key: const Key("App loading"),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsetsDirectional.all(25),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  Widget _buildError() {
    final theme = Theme.of(context);
    return Scaffold(
      key: const Key("App error"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(
              vertical: 45,
              horizontal: kHorizontalSpacing,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 280),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "An error occurred",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _appController!.error?.toString() ??
                        "Something went wrong! Please try again.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: double.maxFinite),
                    child: ElevatedButton(
                      child: const Text(
                        "Retry",
                      ),
                      onPressed: () {
                        _appController!.initialize();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_appController!.authController.isAlreadyLoggedIn())
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                          width: double.maxFinite),
                      child: ElevatedButton(
                        onPressed: () {
                          _appController!.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor.withOpacity(0.05),
                          foregroundColor: theme.colorScheme.primary,
                        ),
                        child: const Text("Sign out"),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForceUpdate() {
    final theme = Theme.of(context);
    return Scaffold(
      key: const Key("App force update"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(
              vertical: 45,
              horizontal: kHorizontalSpacing,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 280),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.system_update_alt,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "New version available",
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _appController!.error?.toString() ??
                        "The current version of the app installed is no longer supported. Please update the app.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: double.maxFinite),
                    child: CustomButton(
                      onClick: () {
                        OpenStore.instance.open(
                          appStoreId: "6479221314",
                          androidAppBundleId: "com.sarahboggs.collegesauce",
                        );
                      },
                      title: 'Update from store',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
