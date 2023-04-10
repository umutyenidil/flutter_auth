import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_input.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/input_values/avatar_image_value.dart';
import 'package:flutter_auth/input_values/input_field_value.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/profile_page/profile_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_update_page_state.dart';

class ProfileUpdatePageCubit extends Cubit<ProfileUpdatePageState> {
  ProfileUpdatePageCubit() : super(ProfileUpdatePageInitial());
  AvatarImageValue? _avatarImageValue;
  InputFieldValue? _usernameInputValue;

  void getAvatarImageValue({required AvatarImageValue value}) {
    _avatarImageValue = value;
  }

  void getUsernameInputValue({required InputFieldValue value}) {
    _usernameInputValue = value;
  }

  Future<void> updateUserProfile(BuildContext context) async {
    UserModelMap data = {};

    if (_usernameInputValue!.status == InputFieldStatusEnum.notMatched) {
      await PopUpMessage.danger(
        title: 'Username error',
        message: 'username alani bos birakilamaz',
      ).show(context);
      return;
    }

    if (_usernameInputValue!.status == InputFieldStatusEnum.updated) {
      data[UserModelField.username] = _usernameInputValue!.value;
    }

    if (_avatarImageValue!.status != AvatarImageStatus.initial) {
      data[UserModelField.avatarImage] = _avatarImageValue!.value;
    }

    if (data.isNotEmpty) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventUpdateUserProfile(data: data),
      );
      return;
    }

    context.pageTransitionScale(
      page: const ProfilePage(),
    );
  }

  Future<void> listenerRemoteStorageBloc(
    BuildContext context, {
    required RemoteStorageState currentState,
  }) async {
    if (currentState is StateSuccessfulUpdateUserProfile) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'Tamamdir',
          message: 'Profiliniz guncellendi',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionScale(
          page: const ProfilePage(),
        );
      }
      return;
    }
    if (currentState is StateFailedUpdateUserProfile) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.danger(
          title: 'bir hata olustu',
          message: currentState.errorMessage,
        ).show(context);
      }
      return;
    }
  }

  bool listenWhenRemoteStorageBloc(
    BuildContext context, {
    required RemoteStorageState previousState,
    required RemoteStorageState currentState,
  }) {
    if (previousState is StateLoadingGetUserProfile && currentState is StateSuccessfulGetUserProfile) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventGetAvatarImageURlList(),
      );
      return false;
    }
    if (currentState is StateLoadingUpdateUserProfile) {
      const PopUpLoading().show(context);
      return false;
    }
    return true;
  }

  bool buildWhenRemoteStorageBloc(
    BuildContext context, {
    required RemoteStorageState previousState,
    required RemoteStorageState currentState,
  }) {
    if (currentState is StateLoadingGetUserProfile) {
      return true;
    }
    if (currentState is StateSuccessfulGetUserProfile) {
      return true;
    }
    return false;
  }

  Future<void> listenerAuthBloc(
    BuildContext context, {
    required AuthState currentState,
  }) async {
    if (currentState is StateSuccessfulDeleteUser) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'hoscakal',
          message: 'hesabin silindi :(',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const SignInPage(),
        );
      }
      return;
    }
    if (currentState is StateFailedDeleteUser) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.danger(
          title: 'Opss!',
          message: currentState.errorMessage,
        ).show(context);
      }
      return;
    }
  }

  bool listenWhenAuthBloc(
    BuildContext context, {
    required AuthState previousState,
    required AuthState currentState,
  }) {
    if (currentState is StateLoadingDeleteUser) {
      const PopUpLoading().show(context);
      return false;
    }
    return true;
  }

  bool buildWhenAuthBloc(
    BuildContext context, {
    required AuthState previousState,
    required AuthState currentState,
  }) {
    return true;
  }

  Future<void> deleteAccountButtonOnPressed(BuildContext context) async {
    await PopUpAcceptable(
      color: Colors.red,
      rightButtonOnPressed: () async {
        Navigator.of(context).pop();
        SecureInputFieldValue value = await showPopUpInput(context);
        BlocProvider.of<AuthBloc>(context).add(
          EventDeleteUser(password: value.value),
        );
      },
      svgIcon: IconPathConstants.deleteIcon,
      description: 'Emin misiniz?',
      title: 'Hesabiniz silinecek',
      leftButtonOnPressed: () {
        Navigator.of(context).pop();
      },
      leftButtonText: 'Cancel',
      rightButtonText: 'Devam et',
    ).show(context);
  }
}
