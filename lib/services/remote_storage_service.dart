import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/models/auth_model.dart';
import 'package:flutter_auth/models/user_model.dart';

class RemoteStorageService {
  RemoteStorageService._privateConstructor();

  static final RemoteStorageService instance = RemoteStorageService._privateConstructor();

  Future<bool> get isCurrentUserProfileCreated async {
    User currentUser = await AuthModel().getCurrentUser();

    UserModelMap? userData = await UserModel().readWithUid(uid: currentUser.uid, fields: [
      UserModelFieldsEnum.avatarImage,
      UserModelFieldsEnum.username,
    ]);

    if (userData == null) {
      return false;
    }

    for (dynamic value in userData.values.toList()) {
      if (value == null) {
        return false;
      }
    }

    return true;
  }
}
