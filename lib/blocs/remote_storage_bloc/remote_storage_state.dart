part of 'remote_storage_bloc.dart';

@immutable
abstract class RemoteStorageState {}

class StateInitial extends RemoteStorageState {}

// EventIsUserProfileCreatedOnCloud
class StateLoadingIsUserProfileCreated extends RemoteStorageState {}

class StateFailedIsUserProfileCreated extends RemoteStorageState {}

class StateTrueUserProfileCreated extends RemoteStorageState {}

class StateFalseUserProfileCreated extends RemoteStorageState {}

// EventCreateUserProfileOnCloud
class StateLoadingCreateUserProfile extends RemoteStorageState {}

class StateSuccessfulCreateUserProfile extends RemoteStorageState {}

class StateFailedCreateUserProfile extends RemoteStorageState {}

// EventGetUserProfile

class StateLoadingGetUserProfile extends RemoteStorageState {}

class StateSuccessfulGetUserProfile extends RemoteStorageState {
  final Map<String, dynamic> userProfileData;

  StateSuccessfulGetUserProfile({required this.userProfileData});
}

class StateFailedGetUserProfile extends RemoteStorageState {}
