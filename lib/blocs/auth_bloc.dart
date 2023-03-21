import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEventSignUpWithEmailAndPassword>((event, emit) async {
      try {
        emit(
          AuthStateSignUpLoading(),
        );
        await UserModel().signUpWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
        );

        emit(
          AuthStateSignUpSuccess(),
        );
      } on UserEmailAlreadyInUseException {
        emit(
          AuthStateSignUpFailed(
            exception: UserEmailAlreadyInUseException(),
          ),
        );
      } on UserInvalidEmailException {
        emit(
          AuthStateSignUpFailed(
            exception: UserInvalidEmailException(),
          ),
        );
      } on UserOperationNotAllowedException {
        emit(
          AuthStateSignUpFailed(
            exception: UserOperationNotAllowedException(),
          ),
        );
      } on UserWeakPasswordException {
        emit(
          AuthStateSignUpFailed(
            exception: UserWeakPasswordException(),
          ),
        );
      } catch (exception) {
        emit(
          AuthStateSignUpFailed(
            exception: UserGenericException(),
          ),
        );
      }
    });
  }
}
