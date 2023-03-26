import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

class SelectButton extends StatelessWidget {
  const SelectButton({
    super.key, required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        onPressed();

      },
      minWidth: 0,
      height: 0,
      color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusConstants.allCorners10,
      ),
      child: Text(
        'Select',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
