part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthEventSignUpWithEmailAndPassword extends AuthEvent {
  final BuildContext context;
  final String emailAddress;
  final String password;

  AuthEventSignUpWithEmailAndPassword({
    required this.context,
    required this.emailAddress,
    required this.password,
  });
}
