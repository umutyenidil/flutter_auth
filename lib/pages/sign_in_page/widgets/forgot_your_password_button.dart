import 'package:flutter/material.dart';

import '../../../typedefs/function_typedefs.dart';

class ForgotYourPasswordButton extends StatelessWidget {
  const ForgotYourPasswordButton({
    super.key,
    required this.onPressed,
  });

  final VoidFunctionWithNoParameter onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: const Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
