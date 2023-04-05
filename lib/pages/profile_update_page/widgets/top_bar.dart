import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/edit_button.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_update_page/profile_update_page.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/save_button.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              BackSvgButton(
                size: 40,
                padding: 4,
                onPressed: () {
                  context.pageTransitionSlide(
                    page: const HomePage(),
                    direction: PageTransitionDirection.leftToRight,
                  );
                },
              ),
              const Spacer(),
              const SizedBox(
                height: 22,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SaveButton(
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
