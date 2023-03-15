import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaSvgButton extends StatelessWidget {
  const SocialMediaSvgButton._({
    Key? key,
    required this.backgroundColor,
    required this.svgIcon,
    required this.onPressed,
    this.iconColor,
  }) : super(key: key);
  final Color backgroundColor;
  final Color? iconColor;
  final String svgIcon;
  final Function onPressed;

  factory SocialMediaSvgButton.apple({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: Colors.white,
      svgIcon: IconPathConstants.appleLogoIcon,
      onPressed: onPressed,
    );
  }

  factory SocialMediaSvgButton.google({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: Colors.white,
      svgIcon: IconPathConstants.googleLogoIcon,
      onPressed: onPressed,
    );
  }

  factory SocialMediaSvgButton.facebook({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: const Color(0xff4267b2),
      svgIcon: IconPathConstants.facebookLogoIcon,
      onPressed: onPressed,
      iconColor: Colors.white,
    );
  }

  factory SocialMediaSvgButton.twitter({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: const Color(0xff1da1f2),
      svgIcon: IconPathConstants.twitterLogoIcon,
      onPressed: onPressed,
      iconColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 48,
      child: MaterialButton(
        color: backgroundColor,
        height: 0,
        minWidth: 0,
        padding: EdgeInsets.all(8),
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          svgIcon,
          color: iconColor,
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
