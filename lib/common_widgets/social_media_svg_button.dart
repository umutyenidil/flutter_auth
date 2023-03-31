import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaSvgButton extends StatelessWidget {
  const SocialMediaSvgButton._({
    Key? key,
    required this.backgroundColor,
    required this.svgIcon,
    required this.onPressed,
    this.iconColor,
    required this.title,
    required this.titleColor,
    this.iconSize = 32,
  }) : super(key: key);
  final Color backgroundColor;
  final Color? iconColor;
  final String svgIcon;
  final double iconSize;
  final Function onPressed;
  final String title;
  final Color titleColor;

  factory SocialMediaSvgButton.apple({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: Colors.white,
      svgIcon: IconPathConstants.appleLogoIcon,
      onPressed: onPressed,
      title: 'Apple',
      titleColor: Colors.black,
    );
  }

  factory SocialMediaSvgButton.google({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: Colors.white,
      svgIcon: IconPathConstants.googleLogoIcon,
      onPressed: onPressed,
      title: 'Google',
      titleColor: Colors.black,
    );
  }

  factory SocialMediaSvgButton.facebook({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: const Color(0xff4267b2),
      svgIcon: IconPathConstants.facebookLogoIcon,
      onPressed: onPressed,
      iconColor: Colors.white,
      titleColor: Colors.white,
      title: 'Facebook',
    );
  }

  factory SocialMediaSvgButton.twitter({required Function onPressed}) {
    return SocialMediaSvgButton._(
      backgroundColor: const Color(0xff1da1f2),
      svgIcon: IconPathConstants.twitterLogoIcon,
      onPressed: onPressed,
      iconColor: Colors.white,
      title: 'Twitter',
      titleColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: MaterialButton(
        color: backgroundColor,
        height: 0,
        minWidth: 0,
        padding: EdgeInsets.symmetric(
          horizontal: iconSize / 4,
          vertical: iconSize / 4,
        ),
        shape: const StadiumBorder(),
        child: SizedBox(
          width: 80,
          height: iconSize,
          child: Row(
            children: [
              SizedBox.square(
                dimension: iconSize,
                child: SvgPicture.asset(
                  svgIcon,
                  color: iconColor,
                ),
              ),
              HorizontalSpace(iconSize / 4),
              SizedBox(
                width: 40,
                height: iconSize / 2,
                child: FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
