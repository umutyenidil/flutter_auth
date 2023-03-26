import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        color: Colors.blue,
        minWidth: 0,
        height: 0,
        padding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusConstants.allCorners10,
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          'Save',
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
