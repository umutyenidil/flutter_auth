import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorConstants {
  static Color popUpBarrierColor = Colors.grey.withOpacity(0.5);

  static Color randomColor({int seed = 1}) => Color((math.Random(seed).nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
