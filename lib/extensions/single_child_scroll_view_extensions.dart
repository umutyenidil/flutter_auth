import 'package:flutter/material.dart';

extension ScrollGlow on SingleChildScrollView {
  Widget removeScrollGlow() {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: this);
  }
}
