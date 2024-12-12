import 'package:flutter/material.dart';
import '../../../config/constants.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key? key,
    required this.child,
    this.enableGradient = true,
    this.gradientColor,
  }) : super(key: key);

  final Widget child;
  final bool enableGradient;
  final Color? gradientColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final hasBottomPadding = media.padding.bottom != 0;
    final effectiveGradientColor =
        gradientColor ?? theme.scaffoldBackgroundColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -50,
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: BoxDecoration(
                gradient: enableGradient
                    ? LinearGradient(
                        colors: [
                          effectiveGradientColor,
                          effectiveGradientColor.withOpacity(0.8),
                          effectiveGradientColor.withOpacity(0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          child: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                kHorizontalSpacing,
                10,
                kHorizontalSpacing,
                hasBottomPadding ? 0 : kBottomBarBottomSpacing,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
