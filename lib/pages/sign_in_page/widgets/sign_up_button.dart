import 'package:flutter/material.dart';
import 'package:flutter_auth/typedefs/function_typedefs.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 12,
  });

  final VoidFunctionWithNoParameter onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          backgroundColor,
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
        ),
        shape: const MaterialStatePropertyAll(
          StadiumBorder(),
        ),
      ),
      child: Text(
        'Sign up',
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
