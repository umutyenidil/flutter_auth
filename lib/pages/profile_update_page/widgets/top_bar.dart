import 'package:flutter/material.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/edit_button.dart';
import 'package:flutter_auth/cubits/profile_update_page_cubit/profile_update_page_cubit.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_page/profile_page.dart';
import 'package:flutter_auth/pages/profile_update_page/profile_update_page.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/save_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  context.pageTransitionScale(
                    page: const ProfilePage(),
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
                size: 40,
                padding: 12,
                onPressed: () {
                  BlocProvider.of<ProfileUpdatePageCubit>(context).updateUserProfile();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
