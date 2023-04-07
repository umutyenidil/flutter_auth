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
            StateFailedCreateUserProfile(errorMessage: '${exception.fieldName} is being used by someone else'),
          );
        } on CurrentUserNotFoundException {
          devtools.log('EventCreateProfile: user profile not created (CurrentUserNotFoundException)');
          emit(
            StateFailedCreateUserProfile(errorMessage: 'The profile could not be created. try again'),
          );
        } on GenericUserModelException {
          devtools.log('EventCreateProfile: user profile not created (GenericUserModelException)');
          emit(
            StateFailedCreateUserProfile(errorMessage: 'The profile could not be created. try again'),
          );
        } on GenericRemoteStorageException {
          devtools.log('EventCreateProfile: user profile not created (GenericRemoteStorageException)');
          emit(
            StateFailedCreateUserProfile(errorMessage: 'The profile could not be created. try again'),
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
              errorMessage: 'You need to create a profile.',
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
            StateFailedGetUserProfile(errorMessage: 'The user could not be found'),
          );
        } on GenericUserModelException {
          devtools.log('EventGetUserProfile: user data wasn\'t read from cloud (GenericUserModelException)');
          emit(
            StateFailedGetUserProfile(errorMessage: 'Something went wrong'),
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
          devtools.log('avatar resimleri getirildi');
          emit(
            StateSuccessfulGetAvatarImageUrlList(
              avatarImageUrlList: avatarImageUrlList,
            ),
          );
        } on GenericRemoteStorageException {
          devtools.log('EventGetAvatarImageURlList: image links not brought in (GenericRemoteStorageException)');
          emit(
            StateFailedGetAvatarImageUrlList(errorMessage: 'bir hata olustu'),
          );
        }
        devtools.log('EventGetAvatarImageURlList: finished');
      },
    );

    on<EventUpdateUserProfile>((event, emit) async {
      devtools.log('EventUpdateUserProfile: started');
      try {
        emit(
          StateLoadingUpdateUserProfile(),
        );
        print('update event');

        await _provider.updateCurrentUserProfile(data: event.data);

        emit(
          StateSuccessfulUpdateUserProfile(),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventUpdateUserProfile: CurrentUserNotFoundException');
        emit(
          StateFailedUpdateUserProfile(errorMessage: 'kullanici bulunamadi'),
        );
      } on GenericAuthModelException {
        devtools.log('EventUpdateUserProfile: GenericAuthModelException');
        emit(
          StateFailedUpdateUserProfile(errorMessage: 'beklenmedik bir hata olustu'),
        );
      } on UserNotUpdatedException {
        devtools.log('EventUpdateUserProfile: UserNotUpdatedException');
        emit(
          StateFailedUpdateUserProfile(errorMessage: 'kullanici guncellenmedi'),
        );
      } on UniqueFieldException catch (e) {
        devtools.log('EventUpdateUserProfile: UniqueFieldException');
        emit(
          StateFailedUpdateUserProfile(errorMessage: '${e.fieldName} degeri kullanimda'),
        );
      } on GenericUserModelException {
        devtools.log('EventUpdateUserProfile: GenericUserModelException');
        emit(
          StateFailedUpdateUserProfile(errorMessage: 'beklenmedik bir hata olustu'),
        );
      } on GenericRemoteStorageException {
        devtools.log('EventUpdateUserProfile: GenericRemoteStorageException');
        emit(
          StateFailedUpdateUserProfile(errorMessage: 'beklenmedik bir hata olustu'),
        );
      }
      devtools.log('EventUpdateUserProfile: finished');
    });
  }
}
