import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: MaterialButton(
        color: Colors.blue,
        minWidth: 0,
        height: 0,
        padding: EdgeInsets.zero,
        shape: const StadiumBorder(),
        onPressed: () {
          onPressed();
        },
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
