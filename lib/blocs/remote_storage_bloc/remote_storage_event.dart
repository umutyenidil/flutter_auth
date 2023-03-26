part of 'remote_storage_bloc.dart';

@immutable
abstract class RemoteStorageEvent {}

class EventCreateUserProfile extends RemoteStorageEvent {
  final Map<String, dynamic> userData;

  EventCreateUserProfile({
    required this.userData,
  });
}

class EventIsUserProfileCreated extends RemoteStorageEvent {}

class EventGetUserProfile extends RemoteStorageEvent {}
