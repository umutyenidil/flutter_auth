import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    super.key,
    required this.onPressed,
    this.size = 32,
    this.padding = 0,
  });

  final Function onPressed;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: MaterialButton(
        color: Colors.white,
        height: 0,
        minWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusConstants.allCorners10,
        ),
        padding: EdgeInsets.zero,
        child: SizedBox.square(
          dimension: size - padding,
          child: SvgPicture.asset(
            IconPathConstants.editIcon,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
