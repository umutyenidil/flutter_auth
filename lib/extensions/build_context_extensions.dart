import 'dart:io' show Platform;

import 'package:flutter/material.dart';

extension ScreenInformations on BuildContext {
  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
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
