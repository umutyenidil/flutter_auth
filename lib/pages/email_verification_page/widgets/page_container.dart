import 'package:flutter/material.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({Key? key, required this.content}) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: content,
          ),
        ),
      ),
    );
  }
}
