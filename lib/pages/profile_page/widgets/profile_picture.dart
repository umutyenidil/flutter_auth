import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/color_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 120,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.randomColor(),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return SvgPicture.asset(
                IconPathConstants.cancelIcon,
                color: Colors.red,
              );
            },
            imageUrl: url,
          ),
        ),
      ),
    );
  }
}
