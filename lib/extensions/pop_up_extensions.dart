import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up.dart';
import 'package:flutter_auth/constants/color_constants.dart';

extension Show on PopUp {
  Future<dynamic> show(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: ColorConstants.popUpBarrierColor,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 2,
            sigmaX: 2,
          ),
          child: Center(
            child: this as Widget?,
          ),
        );
      },
    );
  }
}
