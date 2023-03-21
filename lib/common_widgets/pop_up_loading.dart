import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/lottie_path_constants.dart';
import 'package:lottie/lottie.dart';

class PopUpLoading extends StatelessWidget {
  const PopUpLoading({
    Key? key,
  }) : super(key: key);

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
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Lottie.asset(
            LottiePathConstants.progressIndicatorLottie,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
