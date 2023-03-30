part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class StateInitial extends AuthState {}

// SignUp Event States
class StateSuccessfulSignUpWithEmailAndPassword extends AuthState {}

class StateFailedSignUpWithEmailAndPassword extends AuthState {
  final UserModelException exception;

  StateFailedSignUpWithEmailAndPassword({required this.exception});
}

class StateLoadingSignUpWithEmailAndPassword extends AuthState {}

// SignIn Event States
class StateSuccessfulSignInWithEmailAndPassword extends AuthState {}

class StateFailedSignInWithEmailAndPassword extends AuthState {
  final UserModelException exception;

  StateFailedSignInWithEmailAndPassword({required this.exception});
}

class StateLoadingSignInWithEmailAndPassword extends AuthState {}

// IsUserVerified Event States
class StateLoadingIsUserVerified extends AuthState {}

class StateSuccessfulIsUserVerified extends AuthState {}

class StateFalseUserVerified extends AuthState {}

class StateTrueUserVerified extends AuthState {}

class StateFailedIsUserVerified extends AuthState {
  final UserModelException exception;

  StateFailedIsUserVerified({required this.exception});
}

// SendEmailVerification Event States
class StateLoadingSendEmailVerification extends AuthState {}

class StateSuccessfulSendEmailVerification extends AuthState {}

class StateFailedSendEmailVerification extends AuthState {
  final UserModelException exception;

  StateFailedSendEmailVerification({required this.exception});
}

// Logout Event States

class StateLoadingLogout extends AuthState {}

class StateSuccessfulLogout extends AuthState {}

class StateFailedLogout extends AuthState {
  final UserModelException exception;

  StateFailedLogout({required this.exception});
}

// EventIsUserSignedIn states
class StateLoadingIsUserSignedIn extends AuthState {}

class StateTrueUserSignedIn extends AuthState {}

class StateFalseUserSignedIn extends AuthState {}
