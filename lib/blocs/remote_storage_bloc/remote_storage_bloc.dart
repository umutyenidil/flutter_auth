import 'dart:async';

import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'remote_storage_event.dart';

part 'remote_storage_state.dart';

class RemoteStorageBloc extends Bloc<RemoteStorageEvent, RemoteStorageState> {
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
          print(userProfileData);

          if (userProfileData[UserModelFields.avatarImage] is File) {
            File userProfilePictureFile = userProfileData[UserModelFields.avatarImage];
            String generatedUUID = (Uuid()).v4();
            String userProfilePictureFileExtension = userProfilePictureFile.path.split('.').last;

            Reference storageRef = FirebaseStorage.instance.ref();
            Reference userImagesRef = storageRef.child('user_images/${userUid}');
            Reference userProfilePictureRef = userImagesRef.child('${generatedUUID}.${userProfilePictureFileExtension}');

            await userProfilePictureRef.putFile(userProfilePictureFile);
            devtools.log('EventCreateProfile: profile picture uploaded');

            userProfileData[UserModelFields.avatarImage] = await userProfilePictureRef.getDownloadURL();
            devtools.log('EventCreateProfile: profile picture link brought in');
          }


          await UserModel().updateWithUid(
            uid: user.uid,
            avatarImage: userProfileData[UserModelFields.avatarImage],
            username: userProfileData[UserModelFields.username],
          );

          devtools.log('EventCreateProfile: user profile created');
          emit(
            StateSuccessfulCreateUserProfile(),
          );
        } catch (exception) {
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

          User user = await UserModel().getCurrentUser();
          devtools.log('EventIsUserProfileCreated: current user brought in');

          bool isUserProfileCreated = await UserModel().isUserProfileCreatedOnFirebase(uid: user.uid);

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
        } on UserModelException {
          devtools.log('EventIsUserProfileCreated: user profile not created (UserModelException)');
          emit(
            StateFailedIsUserProfileCreated(),
          );
        } catch (exception) {
          devtools.log('EventIsUserProfileCreated: user profile not created (unhandled exception)');
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
            UserModelFields.avatarImage: userData![UserModelFields.avatarImage],
            UserModelFields.username: userData[UserModelFields.username],
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
