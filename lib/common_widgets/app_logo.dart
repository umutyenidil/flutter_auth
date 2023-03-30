import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              'Flutter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const HorizontalSpace(8),
        SizedBox.square(
          dimension: 64,
          child: FittedBox(
            child: SvgPicture.asset(
              IconPathConstants.fingerprintIcon,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 50,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              'uth',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
