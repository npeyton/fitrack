// Sizes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kAppBarHeight = kToolbarHeight;
const kCupertinoAppBarHeight = 46.0;
const kExpandedAppBarHeight = 110.0;
const kButtonSize = 48.0;

// Spaces
const kHorizontalSpacing = 22.0;
const kVerticalSpacing = 20.0;
const kBottomBarBottomSpacing = 25.0;
const kHorizontalSpacingMedium = 50.0;

const kVerticalSpacingMedium = 60.0;

const kContainerWidth = 400.0;
const kContainerWidthMedium = 750.0;

// Border radius
const kBorderRadius = 15.0;
const kButtonBorderRadius = 50.0;

const kDefaultProfileWidgetSize = 38.0;

//message behavior
const messageChunkSize = 20;

BoxShadow kBoxShadow = BoxShadow(
  color: Colors.black.withOpacity(0.25),
  blurRadius: 10,
  spreadRadius: 2,
  offset: const Offset(1, 5), // Shadow position
);

//group chat
const double messageActionIconSize = 18;
const double messageActionCircleSize = 30;

//navBar
const double navBarIconSize = 27;
const double navBarIconSizeAdder = 4;
const double navBarHeight = navBarIconSize + 15;

const kSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);
