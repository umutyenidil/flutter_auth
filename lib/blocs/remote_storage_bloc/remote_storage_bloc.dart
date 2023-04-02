import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_auth/services/remote_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:uuid/uuid.dart';

part 'remote_storage_event.dart';

part 'remote_storage_state.dart';

class RemoteStorageBloc extends Bloc<RemoteStorageEvent, RemoteStorageState> {
  final RemoteStorageService _provider = RemoteStorageService.instance;

  RemoteStorageBloc() : super(StateInitial()) {
    on<EventCreateUserProfile>(
      (event, emit) async {
        devtools.log('EventCreateProfile: started');

        try {
          emit(
            StateLoadingCreateUserProfile(),
          );

          Map<String, dynamic> userProfileData = event.userData;
          User user = await UserModel().getCurrentUser();
          devtools.log('EventCreateProfile: current user brought in');
          String userUid = user.uid;

          if (userProfileData[UserModelFieldsEnum.avatarImage.value] is File) {
            File userProfilePictureFile = userProfileData[UserModelFieldsEnum.avatarImage.value];
            String generatedUUID = (const Uuid()).v4();
            String userProfilePictureFileExtension = userProfilePictureFile.path.split('.').last;

            Reference storageRef = FirebaseStorage.instance.ref();
            Reference userImagesRef = storageRef.child('user_images/$userUid');
            Reference userProfilePictureRef = userImagesRef.child('$generatedUUID.$userProfilePictureFileExtension');

            await userProfilePictureRef.putFile(userProfilePictureFile);
            devtools.log('EventCreateProfile: profile picture uploaded');

            userProfileData[UserModelFieldsEnum.avatarImage.value] = await userProfilePictureRef.getDownloadURL();
            devtools.log('EventCreateProfile: profile picture link brought in');
          }

          await UserModel().updateWithUid(
            uid: user.uid,
            avatarImage: userProfileData[UserModelFieldsEnum.avatarImage.value],
            username: userProfileData[UserModelFieldsEnum.username.value],
          );

          devtools.log('EventCreateProfile: user profile created');
          emit(
            StateSuccessfulCreateUserProfile(),
          );
        } catch (exception) {
          emit(
            StateFailedCreateUserProfile(),
          );
          devtools.log('EventCreateProfile: user profile not created (unhandled exception)');
          devtools.log(exception.toString());
        }
        devtools.log('EventCreateProfile finished');
      },
    );

    on<EventIsUserProfileCreated>(
      (event, emit) async {
        devtools.log('EventIsUserProfileCreated: started');
        try {
          emit(
            StateLoadingIsUserProfileCreated(),
          );

          bool isUserProfileCreated = await _provider.isCurrentUserProfileCreated;

          if (isUserProfileCreated == true) {
            devtools.log('EventIsUserProfileCreated: user profile created');
            emit(
              StateTrueUserProfileCreated(),
            );
          } else {
            devtools.log('EventIsUserProfileCreated: user profile not created');
            emit(
              StateFalseUserProfileCreated(),
            );
          }
        } on GenericUserModelException {
          devtools.log('EventIsUserProfileCreated: user profile not created (GenericUserModelException)');
          emit(
            StateFailedIsUserProfileCreated(),
          );
        }
        devtools.log('EventIsUserProfileCreated: finished');
      },
    );

    on<EventGetUserProfile>(
      (event, emit) async {
        devtools.log('EventGetUserProfile: started');
        try {
          emit(
            StateLoadingGetUserProfile(),
          );

          User user = await UserModel().getCurrentUser();
          devtools.log('EventGetUserProfile: current user brought in');

          Map<String, dynamic>? userData = await UserModel().readWithUid(
            uid: user.uid,
          );
          devtools.log('EventGetUserProfile: user data was read from cloud');

          Map<String, dynamic> userProfileData = {
            UserModelFieldsEnum.avatarImage.value: userData![UserModelFieldsEnum.avatarImage.value],
            UserModelFieldsEnum.username.value: userData[UserModelFieldsEnum.username.value],
          };

          emit(
            StateSuccessfulGetUserProfile(userProfileData: userProfileData),
          );
        } on UserModelException {
          devtools.log('EventGetUserProfile: user data wasn\'t read from cloud (unhandled exception)');
          emit(
            StateFailedGetUserProfile(),
          );
        } catch (exception) {
          devtools.log('EventGetUserProfile: user data wasn\'t read from cloud (unhandled exception)');
        }
        devtools.log('EventGetUserProfile: finished');
      },
    );

    on<EventGetAvatarImageURlList>(
      (event, emit) async {
        devtools.log('EventGetAvatarImageURlList: started');
        try {
          emit(
            StateLoadingGetAvatarImageUrlList(),
          );

          CollectionReference assetsCollectionReference = FirebaseFirestore.instance.collection('assets');
          DocumentReference avatarImagesDocumentReference = assetsCollectionReference.doc('avatar_images');
          DocumentSnapshot avatarImagesDocumentSnapshot = await avatarImagesDocumentReference.get();
          devtools.log('EventGetAvatarImageURlList: image links brought in');

          Map<String, dynamic> avatarImagesMap = avatarImagesDocumentSnapshot.data() as Map<String, dynamic>;

          emit(
            StateSuccessfulGetAvatarImageUrlList(avatarImageUrlMap: avatarImagesMap),
          );
        } on UserModelException {
          devtools.log('EventGetAvatarImageURlList: image links not brought in (unhandled exception)');

          emit(
            StateFailedGetAvatarImageUrlList(),
          );
        } catch (exception) {
          devtools.log('EventGetAvatarImageURlList: image links not brought in (unhandled exception)');
        }
        devtools.log('EventGetAvatarImageURlList: finished');
      },
    );
  }
}
