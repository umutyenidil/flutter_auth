part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class EventSignUpWithEmailAndPassword extends AuthEvent {
  final String emailAddress;
  final String password;

  EventSignUpWithEmailAndPassword({
    required this.emailAddress,
    required this.password,
  });
}

class EventSignInWithEmailAndPassword extends AuthEvent {
  final String emailAddress;
  final String password;

  EventSignInWithEmailAndPassword({
    required this.emailAddress,
    required this.password,
  });
}

class EventIsUserVerified extends AuthEvent {}

class EventSendEmailVerification extends AuthEvent {}

class EventLogout extends AuthEvent {}

class EventCheckUserAuthentication extends AuthEvent {}

