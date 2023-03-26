import 'dart:developer' as devtools show log;

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(StateInitial()) {
    on<EventSignUpWithEmailAndPassword>(
      (event, emit) async {
        devtools.log('EventSignUpWithEmailAndPassword started');
        try {
          emit(
            StateLoadingSignUp(),
          );
          await UserModel().signUpWithEmailAndPassword(
            emailAddress: event.emailAddress,
            password: event.password,
          );
          emit(
            StateSuccessfulSignUp(),
          );
        } on UserEmailAlreadyInUseException catch (exception) {
          emit(
            StateFailedSignUp(exception: exception),
          );
        } on UserInvalidEmailException catch (exception) {
          emit(
            StateFailedSignUp(exception: exception),
          );
        } on UserOperationNotAllowedException catch (exception) {
          emit(
            StateFailedSignUp(exception: exception),
          );
        } on UserWeakPasswordException catch (exception) {
          emit(
            StateFailedSignUp(exception: exception),
          );
        } catch (exception) {
          emit(
            StateFailedSignUp(exception: UserGenericException()),
          );
        }
        devtools.log('EventSignUpWithEmailAndPassword finished');
      },
    );

    on<EventSignInWithEmailAndPassword>(
      (event, emit) async {
        devtools.log('EventSignInWithEmailAndPassword started');

        try {
          emit(
            StateLoadingSignIn(),
          );
          await UserModel().signInWithEmailAndPassword(
            emailAddress: event.emailAddress,
            password: event.password,
          );
          emit(
            StateSuccessfulSignIn(),
          );
        } on UserInvalidEmailException catch (exception) {
          emit(
            StateFailedSignIn(exception: exception),
          );
        } on UserDisabledException catch (exception) {
          emit(
            StateFailedSignIn(exception: exception),
          );
        } on UserNotFoundException catch (exception) {
          emit(
            StateFailedSignIn(exception: exception),
          );
        } on UserWrongPasswordException catch (exception) {
          emit(
            StateFailedSignIn(exception: exception),
          );
        } on UserDidntSignInException catch (exception) {
          emit(
            StateFailedSignIn(exception: exception),
          );
        } catch (exception) {
          emit(
            StateFailedSignIn(exception: UserGenericException()),
          );
        }
        devtools.log('EventSignInWithEmailAndPassword finished');
      },
    );

    on<EventIsUserVerified>(
      (event, emit) async {
        devtools.log('EventIsUserVerified started');
        try {
          emit(StateLoadingIsUserVerified());
          User currentUser = await UserModel().getCurrentUser();
          await currentUser.reload();

          if (currentUser.emailVerified) {
            emit(
              StateTrueIsUserVerified(),
            );
          } else {
            emit(
              StateFalseIsUserVerified(),
            );
          }
        } catch (exception) {
          emit(
            StateFailedIsUserVerified(exception: UserGenericException()),
          );
        }
        devtools.log('EventIsUserVerified finished');
      },
    );

    on<EventSendEmailVerification>(
      (event, emit) async {
        devtools.log('EventSendEmailVerification started');

        try {
          emit(
            StateLoadingSendEmailVerification(),
          );
          User currentUser = await UserModel().getCurrentUser();

          await currentUser.sendEmailVerification();

          emit(
            StateSuccessfulSendEmailVerification(),
          );
        } catch (exception) {
          emit(
            StateFailedSendEmailVerification(exception: UserGenericException()),
          );
        }

        devtools.log('EventSendEmailVerification finished');
      },
    );

    on<EventLogout>(
      (event, emit) async {
        devtools.log('EventLogout started');

        try {
          emit(
            StateLoadingLogout(),
          );

          await UserModel().logout();

          emit(
            StateSuccessfulLogout(),
          );
        } catch (exception) {
          emit(
            StateFailedLogout(exception: UserGenericException()),
          );
        }
        devtools.log('EventLogout finished');
      },
    );

    on<EventCheckUserAuthentication>(
      (event, emit) async {
        devtools.log('EventCheckUserAuthentication started');

        try {
          await Future.delayed(
            const Duration(seconds: 3),
          );
          User user = await UserModel().getCurrentUser();

          emit(
            StateTrueUserLoggedIn(),
          );
        } on CurrentUserNotFoundException {
          emit(
            StateFalseUserLoggedIn(),
          );
        } catch (exception) {
          print(exception);
        }
        devtools.log('EventCheckUserAuthentication finished');
      },
    );
  }
}
