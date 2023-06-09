import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/constants/error_text_constants.dart';
import 'package:flutter_auth/constants/hint_text_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/input_values/avatar_image_value.dart';
import 'package:flutter_auth/input_values/input_field_value.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_create_page/widgets/avatar_list_view.dart';
import 'package:flutter_auth/pages/profile_create_page/widgets/save_button.dart';
import 'package:flutter_auth/pages/profile_create_page/widgets/top_bar.dart';
import 'package:flutter_auth/pages/profile_create_page/widgets/page_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCreatePage extends StatefulWidget {
  const ProfileCreatePage({Key? key}) : super(key: key);

  @override
  State<ProfileCreatePage> createState() => _ProfileCreatePageState();
}

class _ProfileCreatePageState extends State<ProfileCreatePage> {
  late FocusNode _usernameInputNode;
  InputFieldValue? _usernameInputValue;
  AvatarImageValue? _avatarImageValue;

  @override
  void initState() {
    super.initState();

    _usernameInputNode = FocusNode();

    BlocProvider.of<RemoteStorageBloc>(context).add(
      EventGetAvatarImageURlList(),
    );
  }

  @override
  void dispose() {
    _usernameInputNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
      listener: listenerRemoteStorageBloc,
      listenWhen: listenWhenRemoteStorageBloc,
      builder: (context, state) {
        return Scaffold(
          body: PageContainer(
            content: Column(
              children: [
                const TopBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: AvatarListView(
                    getAvatarImage: (AvatarImageValue value) {
                      _avatarImageValue = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InputField(
                    node: _usernameInputNode,
                    textInputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    regularExpression: RegularExpressionConstants.min8CharacterWithJustLettersAndNumbers,
                    errorMessage: ErrorTextConstants.usernameInputFieldErrorText,
                    hintText: HintTextConstants.usernameInputFieldHintText,
                    getValue: (InputFieldValue? value) {
                      _usernameInputValue = value;
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SaveButton(
                    onPressed: _saveButtonFunction,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveButtonFunction() async {
    context.dismissKeyboard();
    if (_avatarImageValue == null) {
      await PopUpMessage.warning(
        title: 'Avatar error',
        message: 'You must choose an avatar',
      ).show(context);
      return;
    }
    if (_usernameInputValue == null) {
      await PopUpMessage.warning(
        title: 'Username error',
        message: 'The user name cannot be left empty',
      ).show(context);
      return;
    }
    if (_usernameInputValue!.status == InputFieldStatusEnum.notMatched) {
      await PopUpMessage.warning(
        title: 'Username error',
        message: 'Please correct the errors in the username',
      ).show(context);
      return;
    }

    BlocProvider.of<RemoteStorageBloc>(context).add(
      EventCreateUserProfile(
        userData: {
          UserModelField.avatarImage: _avatarImageValue!.value,
          UserModelField.username: _usernameInputValue!.value,
        },
      ),
    );
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateSuccessfulCreateUserProfile) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'You are ready now',
          message: 'Your profile has been created. Now you can use the application',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const HomePage(),
        );
      }
      return;
    }
    if (state is StateFailedCreateUserProfile) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.danger(
          title: 'Profile create error',
          message: state.errorMessage,
        ).show(context);
      }
      return;
    }
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (current is StateLoadingCreateUserProfile) {
      const PopUpLoading().show(context);
      return false;
    }
    return true;
  }
}
