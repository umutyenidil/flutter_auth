import 'package:bloc/bloc.dart';
import 'package:flutter_auth/input_values/avatar_image_value.dart';
import 'package:flutter_auth/input_values/input_field_value.dart';
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

  void updateUserProfile() {
    print(_avatarImageValue ?? 'avatar image value yok');
    print(_usernameInputValue ?? 'username input value yok');
  }
}
