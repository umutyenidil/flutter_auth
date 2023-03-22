part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthEventSignUpWithEmailAndPassword extends AuthEvent {
  final String emailAddress;
  final String password;

  AuthEventSignUpWithEmailAndPassword({
    required this.emailAddress,
    required this.password,
  });
}

class AuthEventSignInWithEmailAndPassword extends AuthEvent {
  final String emailAddress;
  final String password;

  AuthEventSignInWithEmailAndPassword({
    required this.emailAddress,
    required this.password,
  });
}
