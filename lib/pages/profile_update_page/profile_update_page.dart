import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/profile_page/profile_page.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/avatar_list_view.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/save_button.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/delete_account_button.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
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
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BackSvgButton(
                              size: 40,
                              padding: 4,
                              onPressed: () {
                                context.pageTransitionFade(
                                  page: const ProfilePage(),
                                );
                              },
                            ),
                            SaveButton(
                              padding: 16,
                              size: 40,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      AvatarListView(
                        getImageAsByteList: (list) {},
                      ),
                      const VerticalSpace(32),
                      InputField(
                        node: FocusNode(),
                        hintText: 'Kullanici adi giriniz',
                        inputType: TextInputType.text,
                        regularExpression: '',
                        errorMessage: 'test',
                        getValue: (value) {},
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteAccountButton(
                          onPressed: () async {
                            await PopUpAcceptable(
                              color: Colors.red,
                              rightButtonOnPressed: () {},
                              svgIcon: IconPathConstants.deleteIcon,
                              description: 'Emin misiniz?',
                              title: 'Hesabiniz silinecek',
                              leftButtonOnPressed: () {
                                Navigator.of(context).pop();
                              },
                              leftButtonText: 'Cancel',
                              rightButtonText: 'Devam et',
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
        title: 'bir seyler ters gitt',
        message: state.error,
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
