import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

typedef VoidFunctionWithNoParameter = void Function();

class BackTextButton extends StatelessWidget {
  const BackTextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final VoidFunctionWithNoParameter onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        minWidth: 0,
        height: 0,
        padding: EdgeInsets.zero,
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusConstants.allCorners10,
        ),
        child: const Text(
          'BACK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
