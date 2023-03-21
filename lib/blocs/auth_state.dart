part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthStateSignUpSuccess extends AuthInitial {}

class AuthStateSignUpFailed extends AuthInitial {
  final UserModelExceptions exception;

  AuthStateSignUpFailed({required this.exception});
}

class AuthStateSignUpLoading extends AuthInitial {}
