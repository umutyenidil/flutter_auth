part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class StateInitial extends AuthState {}

// SignUp Event States
class StateSuccessfulSignUp extends AuthState {}

class StateFailedSignUp extends AuthState {
  final UserModelException exception;

  StateFailedSignUp({required this.exception});
}

class StateLoadingSignUp extends AuthState {}

// SignIn Event States
class StateSuccessfulSignIn extends AuthState {}

class StateFailedSignIn extends AuthState {
  final UserModelException exception;

  StateFailedSignIn({required this.exception});
}

class StateLoadingSignIn extends AuthState {}

// IsUserVerified Event States
class StateLoadingIsUserVerified extends AuthState {}

class StateSuccessfulIsUserVerified extends AuthState {}

class StateFalseIsUserVerified extends AuthState {}

class StateTrueIsUserVerified extends AuthState {}

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

// Check Authentication states

class StateTrueUserLoggedIn extends AuthState {}

class StateFalseUserLoggedIn extends AuthState {}
