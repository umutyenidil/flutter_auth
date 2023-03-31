import 'package:flutter/material.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/single_child_scroll_view_extensions.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({Key? key, required this.content}) : super(key: key);
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: context.screenHeight,
        width: context.screenWidth,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: content,
          ),
        ),
      ),
    ).removeScrollGlow();
  }
}
