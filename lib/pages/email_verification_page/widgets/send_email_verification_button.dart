import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

class SendEmailVerificationButton extends StatelessWidget {
  const SendEmailVerificationButton({
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
        shape: const StadiumBorder(),
        minWidth: 0,
        height: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          // horizontal: 20,
        ),
        color: Colors.blue,
        child: const Text(
          'Send Email Verification',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
