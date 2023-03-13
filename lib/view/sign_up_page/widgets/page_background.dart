import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/image_path_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageBackground extends StatelessWidget {
  const PageBackground({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              width: context.screenWidth,
              height: context.screenHeight,
              fit: BoxFit.fill,
              ImagePathConstants.authBackgroundImage,
            ),
          ),
          SizedBox(
            width: context.screenWidth,
            height: context.screenHeight,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: child,
            ),
          )
        ],
      ),
    );
  }
}
