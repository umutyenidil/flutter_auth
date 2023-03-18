import 'package:flutter/material.dart';

class SignInTextButton extends StatelessWidget {
  const SignInTextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: const Text('Sign In'),
    );
  }
}
