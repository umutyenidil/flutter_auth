import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        shape: const StadiumBorder(),
        onPressed: () {
          onPressed();
        },
        child: const Text(
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
