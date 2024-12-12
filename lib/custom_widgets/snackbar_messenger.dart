import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';


class SnackBarMessenger extends StatefulWidget {
  const SnackBarMessenger({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  SnackBarMessengerState createState() => SnackBarMessengerState();

  static SnackBarMessengerState of(BuildContext context) {
    final result = context.findAncestorStateOfType<SnackBarMessengerState>();
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'SnackBarMessenger.of() called with a context that does not contain a SnackBarMessenger.',
      ),
      ErrorDescription(
        'No SnackBarMessenger ancestor could be found starting from the context that was passed to SnackBarMessenger.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the StatefulWidget widget being sought.',
      ),
    ]);
  }
}

class SnackBarMessengerState extends State<SnackBarMessenger> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void hideCurrent() {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
  }

  void showDefault(
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final viewportWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        margin: EdgeInsets.only(
          left: isSmallScreen ? 20 : viewportWidth - 350 - 20 - 20,
          top: 0,
          right: 20,
          bottom: 20,
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.blueGrey.shade800,
      ),
    );
  }

  void showInfo(
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final viewportWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        margin: EdgeInsets.only(
          left: isSmallScreen ? 20 : viewportWidth - 350 - 20 - 20,
          top: 0,
          right: 20,
          bottom: 20,
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: action ??
            SnackBarAction(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              label: "Dismiss",
              textColor: Colors.yellow,
            ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void showSuccess(
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final viewportWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        margin: EdgeInsets.only(
          left: isSmallScreen ? 20 : viewportWidth - 350 - 20 - 20,
          top: 0,
          right: 20,
          bottom: 20,
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: action ??
            SnackBarAction(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              label: "Dismiss",
              textColor: Colors.yellow,
            ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showWarning(
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final viewportWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 4),
        margin: EdgeInsets.only(
          left: isSmallScreen ? 20 : viewportWidth - 350 - 20 - 20,
          top: 0,
          right: 20,
          bottom: 30,
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: action ??
            SnackBarAction(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              label: "Dismiss",
              textColor: Colors.yellow,
            ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.orangeAccent.shade400,
      ),
    );
  }

  void showDanger(
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    final viewportWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        margin: EdgeInsets.only(
          left: isSmallScreen ? 20 : viewportWidth - 350 - 20 - 20,
          top: 0,
          right: 20,
          bottom: 20,
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        action: action ??
            SnackBarAction(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              label: "Dismiss",
              textColor: Colors.yellow,
            ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.redAccent.shade400,
      ),
    );
  }
}
