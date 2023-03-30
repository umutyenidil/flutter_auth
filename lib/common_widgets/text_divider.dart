import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key,
    required this.text,
    required this.textColor,
    required this.fontSize,
  });

  final String text;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
