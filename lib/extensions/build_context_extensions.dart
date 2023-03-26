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
