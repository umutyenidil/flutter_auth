import 'package:flutter/material.dart';

class SignUpTextButton extends StatelessWidget {
  const SignUpTextButton({
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
      child: Text('Sign Up'),
    );
  }
}
