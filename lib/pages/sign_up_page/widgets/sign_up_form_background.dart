import 'package:flutter/material.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';

class SignUpFormBackground extends StatelessWidget {
  const SignUpFormBackground({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}
