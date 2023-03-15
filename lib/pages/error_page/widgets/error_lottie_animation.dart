import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/lottie_path_constants.dart';
import 'package:lottie/lottie.dart';

class ErrorLottieAnimation extends StatefulWidget {
  const ErrorLottieAnimation({
    Key? key,
    required this.size,
  }) : super(key: key);
  final double size;

  @override
  State<ErrorLottieAnimation> createState() => _ErrorLottieAnimationState();
}

class _ErrorLottieAnimationState extends State<ErrorLottieAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    _lottieController.addListener(
      () {
        if (_lottieController.status == AnimationStatus.completed) {
          _lottieController.reset();
          _lottieController.forward();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Center(
        child: Lottie.asset(
          LottiePathConstants.errorLottie,
          controller: _lottieController,
          onLoaded: (LottieComposition composition) {
            _lottieController
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();

    super.dispose();
  }
}
