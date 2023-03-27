import 'dart:io' show Platform;

import 'package:flutter/material.dart';

extension ScreenInformations on BuildContext {
  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  double get safeAreaHeight {
    return MediaQuery.of(this).size.height - MediaQuery.of(this).systemGestureInsets.top;
  }
}

extension SelectWidgetByPlatform on BuildContext {
  Widget selectWidgetByPlatform({
    required Widget androidWidget,
    required Widget iosWidget,
  }) {
    if (Platform.isAndroid) {
      return androidWidget;
    } else if (Platform.isIOS) {
      return iosWidget;
    } else {
      throw Exception("The current platform isn't android or ios");
    }
  }
}

extension KeyBoardOperations on BuildContext {
  void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

enum PageTransitionDirection {
  leftToRight,
  rightToLeft,
  bottomToTop,
  topToBottom,
}

extension PageTransitions on BuildContext {
  void pageTransitionSlide({
    required Widget page,
    required PageTransitionDirection direction,
  }) {
    Offset? beginOffset;
    switch (direction) {
      case PageTransitionDirection.leftToRight:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case PageTransitionDirection.rightToLeft:
        beginOffset = const Offset(1.0, 0.0);
        break;
      case PageTransitionDirection.bottomToTop:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case PageTransitionDirection.topToBottom:
        beginOffset = const Offset(0.0, -1.0);
        break;
    }

    PageRouteBuilder pageRouteBuilder = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: beginOffset, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );

    Navigator.of(this).pushReplacement(pageRouteBuilder);
  }

  void pageTransitionFade({required Widget page}) {
    PageRouteBuilder pageRouteBuilder = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );

    Navigator.of(this).pushReplacement(pageRouteBuilder);
  }

  void pageTransitionScale({required Widget page}) {
    PageRouteBuilder pageRouteBuilder = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
    );

    Navigator.of(this).pushReplacement(pageRouteBuilder);
  }
}
