part of 'remote_storage_bloc.dart';

@immutable
abstract class RemoteStorageState {}

class StateInitial extends RemoteStorageState {}

// EventIsUserProfileCreatedOnCloud
class StateLoadingIsUserProfileCreated extends RemoteStorageState {}

class StateFailedIsUserProfileCreated extends RemoteStorageState {
  final String errorMessage;

  StateFailedIsUserProfileCreated({required this.errorMessage});
}

class StateTrueUserProfileCreated extends RemoteStorageState {}

class StateFalseUserProfileCreated extends RemoteStorageState {}

// EventCreateUserProfileOnCloud
class StateLoadingCreateUserProfile extends RemoteStorageState {}

class StateSuccessfulCreateUserProfile extends RemoteStorageState {}

class StateFailedCreateUserProfile extends RemoteStorageState {
  final String errorMessage;

  StateFailedCreateUserProfile({required this.errorMessage});
}

// EventGetUserProfile

class StateLoadingGetUserProfile extends RemoteStorageState {}

class StateSuccessfulGetUserProfile extends RemoteStorageState {
  final UserModelMap userProfileData;

  StateSuccessfulGetUserProfile({required this.userProfileData});
}

class StateFailedGetUserProfile extends RemoteStorageState {
  final String errorMessage;

  StateFailedGetUserProfile({required this.errorMessage});
}

// EventGetAvatarImageUrlList

class StateLoadingGetAvatarImageUrlList extends RemoteStorageState {}

class StateSuccessfulGetAvatarImageUrlList extends RemoteStorageState {
  final List<String> avatarImageUrlList;

  StateSuccessfulGetAvatarImageUrlList({required this.avatarImageUrlList});
}

class StateFailedGetAvatarImageUrlList extends RemoteStorageState {
  final String errorMessage;

  StateFailedGetAvatarImageUrlList({required this.errorMessage});
}

// EventUpdateUserProfile

class StateLoadingUpdateUserProfile extends RemoteStorageState {}

class StateSuccessfulUpdateUserProfile extends RemoteStorageState {}

class StateFailedUpdateUserProfile extends RemoteStorageState {
  final String errorMessage;

  StateFailedUpdateUserProfile({required this.errorMessage});
}
