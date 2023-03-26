import 'dart:async';
import 'dart:typed_data';

import 'dart:developer' as devtools show log;

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:meta/meta.dart';

part 'remote_storage_event.dart';

part 'remote_storage_state.dart';

class RemoteStorageBloc extends Bloc<RemoteStorageEvent, RemoteStorageState> {
  RemoteStorageBloc() : super(StateInitial()) {
    on<EventCreateUserProfile>(
      (event, emit) async {
        devtools.log('EventCreateProfileOnCloud started');

        try {
          emit(
            StateLoadingCreateUserProfile(),
          );

          await Future.delayed(const Duration(seconds: 2));
          Map<String, dynamic> userData = event.userData;

          User user = await UserModel().getCurrentUser();

          await UserModel().updateWithUid(
            uid: user.uid,
            avatarImage: userData[UserModelFields.avatarImage],
            username: userData[UserModelFields.username],
          );

          emit(
            StateSuccessfulCreateUserProfile(),
          );
        } on UserModelException {
          emit(
            StateFailedCreateUserProfile(),
          );
        } catch (exception) {
          print(exception);
        }
        devtools.log('EventCreateProfileOnCloud finished');
      },
    );

    on<EventIsUserProfileCreated>(
      (event, emit) async {
        devtools.log('EventIsUserProfileCreatedOnCloud started');
        try {
          emit(
            StateLoadingIsUserProfileCreated(),
          );

          User user = await UserModel().getCurrentUser();
          bool isUserProfileCreated = await UserModel().isUserProfileCreatedOnFirebase(uid: user.uid);

          if (isUserProfileCreated == true) {
            emit(
              StateTrueUserProfileCreated(),
            );
          } else {
            emit(
              StateFalseUserProfileCreated(),
            );
          }
        } on UserModelException {
          emit(
            StateFailedIsUserProfileCreated(),
          );
        } catch (exception) {
          print(exception);
        }
        devtools.log('EventIsUserProfileCreatedOnCloud finished');
      },
    );

    on<EventGetUserProfile>(
      (event, emit) async {
        devtools.log('EventGetUserProfile started');
        try {
          emit(
            StateLoadingGetUserProfile(),
          );

          User user = await UserModel().getCurrentUser();
          Map<String, dynamic>? userData = await UserModel().readWithUid(uid: user.uid);

          Map<String, dynamic> userProfileData = {
            UserModelFields.avatarImage: userData![UserModelFields.avatarImage],
            UserModelFields.username: userData![UserModelFields.username],
          };

          emit(
            StateSuccessfulGetUserProfile(userProfileData: userProfileData),
          );
        } on UserModelException {
          emit(
            StateFailedGetUserProfile(),
          );
        } catch (exception) {
          print(exception);
        }
        devtools.log('EventGetUserProfile finished');
      },
    );
  }
}
