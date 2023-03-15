import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackSvgButton extends StatelessWidget {
  const BackSvgButton({Key? key, required this.onPressed}) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: MaterialButton(
        color: Colors.white,
        height: 0,
        minWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusConstants.allCorners10,
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          IconPathConstants.chevronLeftIcon,
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
