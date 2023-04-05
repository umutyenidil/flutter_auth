import 'dart:developer' as devtools show log;

import 'package:flutter/foundation.dart';
import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';
import 'package:flutter_auth/exceptions/remote_storage_exceptions.dart';
import 'package:flutter_auth/services/remote_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';

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

          await _provider.createUserProfile(
            userData: event.userData,
          );

          devtools.log('EventCreateProfile: user profile created');
          emit(
            StateSuccessfulCreateUserProfile(),
          );
        } on UniqueFieldException catch (exception) {
          devtools.log('EventCreateProfile: user profile not created (UniqueFieldException)');
          emit(
            StateFailedCreateUserProfile(error: '${exception.fieldName} is being used by someone else'),
          );
        } on CurrentUserNotFoundException {
          devtools.log('EventCreateProfile: user profile not created (CurrentUserNotFoundException)');
          emit(
            StateFailedCreateUserProfile(error: 'The profile could not be created. try again'),
          );
        } on GenericUserModelException {
          devtools.log('EventCreateProfile: user profile not created (GenericUserModelException)');
          emit(
            StateFailedCreateUserProfile(error: 'The profile could not be created. try again'),
          );
        } on GenericRemoteStorageException {
          devtools.log('EventCreateProfile: user profile not created (GenericRemoteStorageException)');
          emit(
            StateFailedCreateUserProfile(error: 'The profile could not be created. try again'),
          );
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
            StateFailedIsUserProfileCreated(
              error: 'You need to create a profile.',
            ),
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

          UserModelMap userProfileData = await _provider.userProfile;

          emit(
            StateSuccessfulGetUserProfile(userProfileData: userProfileData),
          );
        } on CurrentUserNotFoundException {
          devtools.log('EventGetUserProfile: user data wasn\'t read from cloud (CurrentUserNotFoundException)');
          emit(
            StateFailedGetUserProfile(error: 'The user could not be found'),
          );
        } on GenericUserModelException {
          devtools.log('EventGetUserProfile: user data wasn\'t read from cloud (GenericUserModelException)');
          emit(
            StateFailedGetUserProfile(error: 'Something went wrong'),
          );
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

          List<String> avatarImageUrlList = await _provider.avatarImageUrlList;

          emit(
            StateSuccessfulGetAvatarImageUrlList(
              avatarImageUrlList: avatarImageUrlList,
            ),
          );
        } on GenericRemoteStorageException {
          devtools.log('EventGetAvatarImageURlList: image links not brought in (GenericRemoteStorageException)');
          emit(
            StateFailedGetAvatarImageUrlList(error: 'bir hata olustu'),
          );
        }
        devtools.log('EventGetAvatarImageURlList: finished');
      },
    );
  }
}
