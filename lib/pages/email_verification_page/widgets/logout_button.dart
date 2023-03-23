
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusConstants.allCorners10,
        ),
        minWidth: 0,
        height: 0,
        padding: EdgeInsets.symmetric(
          vertical: 12,
          // horizontal: 20,
        ),
        color: Colors.red,
        child: Text(
          'Log out',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
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
