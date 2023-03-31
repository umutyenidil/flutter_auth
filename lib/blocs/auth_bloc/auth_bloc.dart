import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(StateInitial()) {
    on<EventSignUpWithEmailAndPassword>(
      (event, emit) async {
        devtools.log('EventSignUpWithEmailAndPassword: started');
        try {
          emit(
            StateLoadingSignUpWithEmailAndPassword(),
          );
          await UserModel().signUpWithEmailAndPassword(
            emailAddress: event.emailAddress,
            password: event.password,
          );

          devtools.log('EventSignUpWithEmailAndPassword: user signed up');
          emit(
            StateSuccessfulSignUpWithEmailAndPassword(),
          );
        } on UserEmailAlreadyInUseException catch (exception) {
          devtools.log('EventSignUpWithEmailAndPassword: user not signed up (UserEmailAlreadyInUseException)');
          emit(
            StateFailedSignUpWithEmailAndPassword(exception: exception),
          );
        } on UserInvalidEmailException catch (exception) {
          devtools.log('EventSignUpWithEmailAndPassword: user not signed up (UserInvalidEmailException)');
          emit(
            StateFailedSignUpWithEmailAndPassword(exception: exception),
          );
        } on UserOperationNotAllowedException catch (exception) {
          devtools.log('EventSignUpWithEmailAndPassword: user not signed up (UserOperationNotAllowedException)');
          emit(
            StateFailedSignUpWithEmailAndPassword(exception: exception),
          );
        } on UserWeakPasswordException catch (exception) {
          devtools.log('EventSignUpWithEmailAndPassword: user not signed up (UserWeakPasswordException)');
          emit(
            StateFailedSignUpWithEmailAndPassword(exception: exception),
          );
        } catch (exception) {
          devtools.log('EventSignUpWithEmailAndPassword: user not signed up (unhandled exception)');
          emit(
            StateFailedSignUpWithEmailAndPassword(exception: UserGenericException()),
          );
        }
        devtools.log('EventSignUpWithEmailAndPassword finished');
      },
    );

    on<EventSignInWithEmailAndPassword>(
      (event, emit) async {
        devtools.log('EventSignInWithEmailAndPassword: started');

        try {
          emit(
            StateLoadingSignInWithEmailAndPassword(),
          );
          await UserModel().signInWithEmailAndPassword(
            emailAddress: event.emailAddress,
            password: event.password,
          );

          devtools.log('EventSignInWithEmailAndPassword: user signed in');
          emit(
            StateSuccessfulSignInWithEmailAndPassword(),
          );
        } on UserInvalidEmailException catch (exception) {
          devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserInvalidEmailException)');
          emit(
            StateFailedSignInWithEmailAndPassword(exception: exception),
          );
        } on UserDisabledException catch (exception) {
          devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserDisabledException)');

          emit(
            StateFailedSignInWithEmailAndPassword(exception: exception),
          );
        } on UserNotFoundException catch (exception) {
          devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserNotFoundException)');

          emit(
            StateFailedSignInWithEmailAndPassword(exception: exception),
          );
        } on UserWrongPasswordException catch (exception) {
          devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserWrongPasswordException)');

          emit(
            StateFailedSignInWithEmailAndPassword(exception: exception),
          );
        } on UserDidntSignInException catch (exception) {
          devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserDidntSignInException)');

          emit(
            StateFailedSignInWithEmailAndPassword(exception: exception),
          );
        } catch (exception) {
          devtools.log('EventSignInWithEmailAndPassword: user not signed in (unhandled exception)');
          emit(
            StateFailedSignInWithEmailAndPassword(exception: UserGenericException()),
          );
        }
        devtools.log('EventSignInWithEmailAndPassword: finished');
      },
    );

    on<EventIsUserVerified>(
      (event, emit) async {
        devtools.log('EventIsUserVerified: started');
        try {
          emit(
            StateLoadingIsUserVerified(),
          );

          User currentUser = await UserModel().getCurrentUser();

          if (currentUser.emailVerified) {
            devtools.log('EventIsUserVerified: user verified');
            emit(
              StateTrueUserVerified(),
            );
          } else {
            devtools.log('EventIsUserVerified: user not verified');
            emit(
              StateFalseUserVerified(),
            );
          }
        } catch (exception) {
          devtools.log('EventIsUserVerified: user not verified (unhandled exception)');
          emit(
            StateFailedIsUserVerified(
              exception: UserGenericException(),
            ),
          );
        }
        devtools.log('EventIsUserVerified: finished');
      },
    );

    on<EventSendEmailVerification>(
      (event, emit) async {
        devtools.log('EventSendEmailVerification: started');

        try {
          emit(
            StateLoadingSendEmailVerification(),
          );
          User currentUser = await UserModel().getCurrentUser();

          await currentUser.sendEmailVerification();

          devtools.log('EventSendEmailVerification: email has been sent');
          emit(
            StateSuccessfulSendEmailVerification(),
          );
        } catch (exception) {
          devtools.log('EventSendEmailVerification: email hasn\'t been sent (unhandled exception)');
          emit(
            StateFailedSendEmailVerification(exception: UserGenericException()),
          );
        }

        devtools.log('EventSendEmailVerification finished');
      },
    );

    on<EventLogout>(
      (event, emit) async {
        devtools.log('EventLogout: started');

        try {
          emit(
            StateLoadingLogout(),
          );

          await UserModel().logout();

          devtools.log('EventLogout: user logged out');
          emit(
            StateSuccessfulLogout(),
          );
        } catch (exception) {
          devtools.log('EventLogout: not logged out (unhandled exception)');
          emit(
            StateFailedLogout(exception: UserGenericException()),
          );
        }
        devtools.log('EventLogout: finished');
      },
    );

    on<EventIsUserSignedIn>(
      (event, emit) async {
        devtools.log('EventIsUserSignedIn: started');

        try {
          emit(
            StateLoadingIsUserSignedIn(),
          );

          await UserModel().getCurrentUser();
          await Future.delayed(
            const Duration(seconds: 3),
          );

          devtools.log('EventIsUserSignedIn: user signed in');
          emit(
            StateTrueUserSignedIn(),
          );
        } on CurrentUserNotFoundException {
          devtools.log('EventIsUserSignedIn: user not signed in');
          emit(
            StateFalseUserSignedIn(),
          );
        } catch (exception) {
          devtools.log('EventIsUserSignedIn: user not signed in (unhandled exception)');

          // print(exception);
        }
        devtools.log('EventIsUserSignedIn: finished');
      },
    );
  }
}
