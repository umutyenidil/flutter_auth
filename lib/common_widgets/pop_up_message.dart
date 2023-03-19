import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PopUpMessageType {
  primary,
  success,
  danger,
  warning,
  info,
}

class PopUp {
  PopUp({
    required this.title,
    required this.message,
    required PopUpMessageType type,
  }) {
    switch (type) {
      case PopUpMessageType.primary:
        color = const Color(0xff0d6efd);
        break;
      case PopUpMessageType.success:
        color = const Color(0xff198754);
        break;
      case PopUpMessageType.danger:
        color = const Color(0xffdc3545);
        break;
      case PopUpMessageType.warning:
        color = const Color(0xffffc107);
        break;
      case PopUpMessageType.info:
        color = const Color(0xff0dcaf0);
        break;
    }
  }

  final String title;
  final String message;
  Color color = const Color(0xff0d6efd);

  Future<dynamic> show(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 2,
            sigmaX: 2,
          ),
          child: Center(
            child: _PopUpMessage(
              color: color,
              message: message,
              title: title,
            ),
          ),
        );
      },
    );
  }
}

class _PopUpMessage extends StatelessWidget {
  const _PopUpMessage({
    Key? key,
    required this.message,
    required this.color,
    required this.title,
  }) : super(key: key);
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 256,
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: SizedBox.square(
                    dimension: 56,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SvgPicture.asset(
                        IconPathConstants.warningIcon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const VerticalSpace(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    height: 0,
                    minWidth: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CLOSE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const VerticalSpace(8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
