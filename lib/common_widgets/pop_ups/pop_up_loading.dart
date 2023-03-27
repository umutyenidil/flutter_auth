import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up.dart';
import 'package:flutter_auth/constants/lottie_path_constants.dart';
import 'package:lottie/lottie.dart';

class PopUpLoading extends StatelessWidget implements PopUp {
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
        width: 256 * 0.75,
        height: 240 * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Lottie.asset(
            LottiePathConstants.clockLottie ,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
