import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({
    super.key,
    required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        color: Colors.red,
        minWidth: 0,
        height: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 12,
        ),
        shape: const StadiumBorder(),
        onPressed: () {
          onPressed();
        },
        child: const Text(
          'Delete My Account',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
