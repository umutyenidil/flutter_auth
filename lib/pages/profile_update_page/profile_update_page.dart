import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/error_text_constants.dart';
import 'package:flutter_auth/constants/hint_text_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/cubits/profile_update_page_cubit/profile_update_page_cubit.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/input_values/avatar_image_value.dart';
import 'package:flutter_auth/input_values/input_field_value.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/avatar_list_view.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/page_container.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/delete_account_button.dart';
import 'package:flutter_auth/pages/profile_update_page/widgets/top_bar.dart';
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
      buildWhen: buildWhenRemoteStorageBloc,
      builder: (context, state) {
        if (state is StateSuccessfulGetUserProfile) {
          UserModelMap userProfileData = state.userProfileData;
          InputFieldValue usernameInitialValue = InputFieldValue(
            value: userProfileData[UserModelField.username],
            status: InputFieldStatusEnum.initial,
          );

          AvatarImageValue avatarImageInitivalValue = AvatarImageValue(
            value: userProfileData[UserModelField.avatarImage],
            status: AvatarImageStatus.initial,
          );

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
                      AvatarListView(
                        getAvatarImage: (AvatarImageValue value) {
                          BlocProvider.of<ProfileUpdatePageCubit>(context).getAvatarImageValue(
                            value: value,
                          );
                        },
                        initialAvatarImageValue: avatarImageInitivalValue,
                      ),
                      const VerticalSpace(32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: InputField(
                          initialValue: usernameInitialValue,
                          node: FocusNode(),
                          hintText: HintTextConstants.usernameInputFieldHintText,
                          inputType: TextInputType.text,
                          regularExpression: RegularExpressionConstants.min8CharacterWithJustLettersAndNumbers,
                          errorMessage: ErrorTextConstants.usernameInputFieldErrorText,
                          getValue: (InputFieldValue? value) {
                            BlocProvider.of<ProfileUpdatePageCubit>(context).getUsernameInputValue(
                              value: value!,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeleteAccountButton(
                          onPressed: () async {
                            await BlocProvider.of<ProfileUpdatePageCubit>(context).deleteAccountButtonOnPressed(context);
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

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    BlocProvider.of<ProfileUpdatePageCubit>(context).listenerRemoteStorageBloc(
      context,
      currentState: state,
    );
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    return BlocProvider.of<ProfileUpdatePageCubit>(context).listenWhenRemoteStorageBloc(
      context,
      previousState: previous,
      currentState: current,
    );
  }

  bool buildWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    return BlocProvider.of<ProfileUpdatePageCubit>(context).buildWhenRemoteStorageBloc(
      context,
      previousState: previous,
      currentState: current,
    );
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    BlocProvider.of<ProfileUpdatePageCubit>(context).listenerAuthBloc(
      context,
      currentState: state,
    );
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    return BlocProvider.of<ProfileUpdatePageCubit>(context).listenWhenAuthBloc(
      context,
      previousState: previous,
      currentState: current,
    );
  }

  bool buildWhenAuthBloc(AuthState previous, AuthState current) {
    return BlocProvider.of<ProfileUpdatePageCubit>(context).buildWhenAuthBloc(
      context,
      previousState: previous,
      currentState: current,
    );
  }
}
