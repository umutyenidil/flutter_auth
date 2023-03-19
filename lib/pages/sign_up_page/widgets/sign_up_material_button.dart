import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';

typedef VoidFunctionWithNoParameter = void Function();

class SignUpMaterialButton extends StatelessWidget {
  const SignUpMaterialButton({Key? key, required this.onPressed}) : super(key: key);
  final VoidFunctionWithNoParameter onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: MaterialButton(
        color: Colors.blue,
        minWidth: 0,
        height: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusConstants.allCorners10,
        ),
        onPressed: () {
          onPressed();
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
