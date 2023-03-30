import 'package:flutter/material.dart';
import 'dart:math' as math;


class ColorConstants {
  static Color popUpBarrierColor = Colors.grey.withOpacity(0.5);
  static Color randomColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
