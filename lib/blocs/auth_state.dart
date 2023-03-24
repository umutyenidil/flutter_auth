part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

// SignUp Event States
class AuthStateSignUpSuccess extends AuthState {}

class AuthStateSignUpFailed extends AuthState {
  final UserModelException exception;

  AuthStateSignUpFailed({required this.exception});
}

class AuthStateSignUpLoading extends AuthState {}

// SignIn Event States
class AuthStateSignInSuccess extends AuthState {}

class AuthStateSignInFailed extends AuthState {
  final UserModelException exception;

  AuthStateSignInFailed({required this.exception});
}

class AuthStateSignInLoading extends AuthState {}

// IsUserVerified Event States
class AuthStateIsUserVerifiedLoading extends AuthState {}

class AuthStateIsUserVerifiedSuccess extends AuthState {}

class AuthStateIsUserVerifiedNotVerified extends AuthState {}

class AuthStateIsUserVerifiedVerified extends AuthState {}

class AuthStateIsUserVerifiedFailed extends AuthState {
  final UserModelException exception;

  AuthStateIsUserVerifiedFailed({required this.exception});
}

// SendEmailVerification Event States
class AuthStateSendEmailVerificationLoading extends AuthState {}

class AuthStateSendEmailVerificationSuccess extends AuthState {}

class AuthStateSendEmailVerificationFailed extends AuthState {
  final UserModelException exception;

  AuthStateSendEmailVerificationFailed({required this.exception});
}

// Logout Event States

class AuthStateLogoutLoading extends AuthState {}

class AuthStateLogoutSuccess extends AuthState {}

class AuthStateLogoutFailed extends AuthState {
  final UserModelException exception;

  AuthStateLogoutFailed({required this.exception});
}
