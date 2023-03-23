import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/image_path_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageField extends StatelessWidget {
  const ImageField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 256,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          ImagePathConstants.verifyEmailImage,
        ),
      ),
    );
  }
}
