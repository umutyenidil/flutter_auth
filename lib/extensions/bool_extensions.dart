import 'package:flutter/material.dart';

extension SelectWidget on bool {
  Widget ifTrueSelectFirstWidget({required Widget firstWidget, required Widget secondWidget}) {
    return this ? firstWidget : secondWidget;
  }
}
