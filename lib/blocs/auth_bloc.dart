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
      } on UserEmailAlreadyInUseException catch (exception) {
        emit(
          AuthStateSignUpFailed(exception: exception),
        );
      } on UserInvalidEmailException catch (exception) {
        emit(
          AuthStateSignUpFailed(exception: exception),
        );
      } on UserOperationNotAllowedException catch (exception) {
        emit(
          AuthStateSignUpFailed(exception: exception),
        );
      } on UserWeakPasswordException catch (exception) {
        emit(
          AuthStateSignUpFailed(exception: exception),
        );
      } catch (exception) {
        emit(
          AuthStateSignUpFailed(exception: UserGenericException()),
        );
      }
    });

    on<AuthEventSignInWithEmailAndPassword>((event, emit) async {
      try {
        emit(
          AuthStateSignInLoading(),
        );
        await UserModel().signInWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
        );
        emit(
          AuthStateSignInSuccess(),
        );
      } on UserInvalidEmailException catch (exception) {
        emit(
          AuthStateSignInFailed(exception: exception),
        );
      } on UserDisabledException catch (exception) {
        emit(
          AuthStateSignInFailed(exception: exception),
        );
      } on UserNotFoundException catch (exception) {
        emit(
          AuthStateSignInFailed(exception: exception),
        );
      } on UserWrongPasswordException catch (exception) {
        emit(
          AuthStateSignInFailed(exception: exception),
        );
      } on UserDidntSignInException catch (exception) {
        emit(
          AuthStateSignInFailed(exception: exception),
        );
      } catch (exception) {
        emit(
          AuthStateSignInFailed(exception: UserGenericException()),
        );
      }
    });
  }
}
