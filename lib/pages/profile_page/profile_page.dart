import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/edit_button.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/color_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_page/widgets/logout_button.dart';
import 'package:flutter_auth/pages/profile_page/widgets/page_container.dart';
import 'package:flutter_auth/pages/profile_page/widgets/profile_picture.dart';
import 'package:flutter_auth/pages/profile_page/widgets/top_bar.dart';
import 'package:flutter_auth/pages/profile_update_page/profile_update_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<RemoteStorageBloc>(context).add(
      EventGetUserProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
      listener: listenerRemoteStorageBloc,
      listenWhen: listenWhenRemoteStorageBloc,
      builder: (context, state) {
        if (state is StateSuccessfulGetUserProfile) {
          UserModelMap userProfileData = state.userProfileData;
          return BlocConsumer<AuthBloc, AuthState>(
            listener: listenerAuthBloc,
            listenWhen: listenWhenAuthBloc,
            builder: (context, state) {
              return Scaffold(
                body: PageContainer(
                  content: Column(
                    children: [
                      const TopBar(),
                      const VerticalSpace(16),
                      ProfilePicture(
                        url: userProfileData[UserModelField.avatarImage],
                      ),
                      const VerticalSpace(32),
                      Text(
                        userProfileData[UserModelField.username],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LogoutButton(
                          onPressed: () async {
                            await PopUpAcceptable(
                              color: Colors.red,
                              svgIcon: IconPathConstants.logoutIcon,
                              title: 'You are logging out',
                              description: 'Are you sure?',
                              leftButtonText: 'Cancel',
                              leftButtonOnPressed: () {
                                Navigator.of(context).pop();
                              },
                              rightButtonText: 'Logout',
                              rightButtonOnPressed: () {
                                Navigator.of(context).pop();
                                BlocProvider.of<AuthBloc>(context).add(
                                  EventLogout(),
                                );
                              },
                            ).show(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(
            child: PopUpLoading(),
          ),
        );
      },
    );
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {}

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    return true;
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateLoadingLogout) {
      const PopUpLoading().show(context);
    }

    if (state is StateSuccessfulLogout) {
      context.pageTransitionFade(
        page: const SignInPage(),
      );
    }

    if (state is StateFailedLogout) {
      await PopUpMessage.danger(
        title: 'bir seyler ters gitti',
        message: state.errorMessage,
      ).show(context);
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (previous is StateLoadingLogout && current is! StateLoadingLogout) {
      Navigator.of(context).pop();
    }
    return true;
  }
}
