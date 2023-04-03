import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';
import 'package:flutter_auth/exceptions/remote_storage_exceptions.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/auth_model.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> createUserProfile({required UserModelMap userData}) async {
    try {
      User user = await AuthModel().getCurrentUser();
      String userUid = user.uid;

      if (userData[UserModelFieldsEnum.avatarImage] is File) {
        String imageUrl = await _uploadFile(
          file: userData[UserModelFieldsEnum.avatarImage.value],
          path: 'user_images/$userUid',
        );

        userData[UserModelFieldsEnum.avatarImage] = imageUrl;
      }

      await UserModel().updateWithUid(uid: userUid, data: {
        UserModelFieldsEnum.username: userData[UserModelFieldsEnum.username],
        UserModelFieldsEnum.avatarImage: userData[UserModelFieldsEnum.avatarImage],
      });
    } on UniqueFieldException {
      rethrow;
    } on CurrentUserNotFoundException {
      rethrow;
    } on GenericUserModelException {
      rethrow;
    } catch (exception) {
      throw GenericRemoteStorageException(exception: exception.toString());
    }
  }

  Future<String> _uploadFile({required File file, required String path}) async {
    try {
      String generatedUUID = (const Uuid()).v4();
      String originalFileExtension = file.path.split('.').last;
      String newFileName = '$generatedUUID.$originalFileExtension';

      Reference storageRef = FirebaseStorage.instance.ref();
      Reference folderRef = storageRef.child(path);
      Reference fileRef = folderRef.child(newFileName);
      await fileRef.putFile(file);

      String fileUrl = await fileRef.getDownloadURL();

      return fileUrl;
    } catch (exception) {
      throw GenericRemoteStorageException(exception: exception.toString());
    }
  }

  Future<UserModelMap> get userProfile async {
    try {
      User user = await AuthModel().getCurrentUser();
      String userUid = user.uid;

      UserModelMap? userProfileData = await UserModel().readWithUid(uid: userUid, fields: [
        UserModelFieldsEnum.username,
        UserModelFieldsEnum.avatarImage,
      ]);

      return userProfileData!;
    } on CurrentUserNotFoundException {
      rethrow;
    } on GenericUserModelException {
      rethrow;
    }
  }

  Future<List<String>> get avatarImageUrlList async {
    try {
      CollectionReference assetsColRef = FirebaseFirestore.instance.collection('assets');
      DocumentReference avatarImagesDocRef = assetsColRef.doc('avatar_images');
      DocumentSnapshot avatarImagesDocSnapshot = await avatarImagesDocRef.get();
      Map<String, dynamic> avatarImagesMap = avatarImagesDocSnapshot.data() as Map<String, dynamic>;

      List<String> avatarImageList = [];
      for (String url in avatarImagesMap.values.toList()) {
        if (url != null) {
          avatarImageList.add(url);
        }
      }

      return avatarImageList;
    } catch (e) {
      throw GenericRemoteStorageException(
        exception: e.toString(),
      );
    }
  }
}
