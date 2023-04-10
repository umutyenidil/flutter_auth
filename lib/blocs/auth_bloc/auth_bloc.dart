import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _provider = AuthService.instance;

  AuthBloc() : super(StateInitial()) {
    on<EventSignUpWithEmailAndPassword>((event, emit) async {
      devtools.log('EventSignUpWithEmailAndPassword: started');
      try {
        emit(
          StateLoadingSignUpWithEmailAndPassword(),
        );
        await _provider.signUpWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
        );
        devtools.log('EventSignUpWithEmailAndPassword: user signed up');
        emit(
          StateSuccessfulSignUpWithEmailAndPassword(),
        );
      } on UserNotSignedUpException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (UserNotSignedUpException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'Account could not be created'),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (CurrentUserNotFoundException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'Account could not be created'),
        );
      } on EmailAlreadyInUseException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (EmailAlreadyInUseException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'The email address is being used by someone else'),
        );
      } on InvalidEmailException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (InvalidEmailException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'You have entered an invalid email address'),
        );
      } on OperationNotAllowedException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (OperationNotAllowedException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'An attempt was made to make an invalid transaction. Get in touch with your managers'),
        );
      } on WeakPasswordException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (WeakPasswordException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'Your password is weak. Please use a stronger password'),
        );
      } on GenericAuthModelException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (GenericAuthModelException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'Something went wrong. Please try again'),
        );
      } on GenericUserModelException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (GenericUserModelException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'Something went wrong. Please try again'),
        );
      }
      devtools.log('EventSignUpWithEmailAndPassword finished');
    });

    on<EventSignInWithEmailAndPassword>((event, emit) async {
      devtools.log('EventSignInWithEmailAndPassword: started');

      try {
        emit(
          StateLoadingSignInWithEmailAndPassword(),
        );

        await _provider.signInWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
        );

        devtools.log('EventSignInWithEmailAndPassword: user signed in');
        emit(
          StateSuccessfulSignInWithEmailAndPassword(),
        );
      } on InvalidEmailException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (InvalidEmailException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'You have entered an invalid e-mail.'),
        );
      } on UserDisabledException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserDisabledException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'Your account is disabled. Please contact your managers'),
        );
      } on UserNotFoundException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserNotFoundException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'The email or password is not correct. Please check your information'),
        );
      } on WrongPasswordException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (WrongPasswordException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'The email or password is not correct. Please check your information'),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (CurrentUserNotFoundException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'The user could not be found.'),
        );
      } on GenericUserModelException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (GenericUserModelException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'Something went wrong. Please try again'),
        );
      } on GenericAuthModelException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (GenericAuthModelException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'Something went wrong. Please try again'),
        );
      }
      devtools.log('EventSignInWithEmailAndPassword: finished');
    });

    on<EventIsUserVerified>((event, emit) async {
      devtools.log('EventIsUserVerified: started');
      try {
        emit(
          StateLoadingIsUserVerified(),
        );
        bool isCurrentUserVerified = await _provider.isCurrentUserVerified;
        if (isCurrentUserVerified) {
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
      } on CurrentUserNotFoundException {
        devtools.log('EventIsUserVerified: user not verified (unhandled exception)');
        emit(
          StateFailedIsUserVerified(
            errorMessage: 'Your email address has not been verified',
          ),
        );
      } on GenericAuthModelException {
        devtools.log('EventIsUserVerified: user not verified (unhandled exception)');
        emit(
          StateFailedIsUserVerified(
            errorMessage: 'Something went wrong',
          ),
        );
      }
      devtools.log('EventIsUserVerified: finished');
    });

    on<EventSendEmailVerification>((event, emit) async {
      devtools.log('EventSendEmailVerification: started');
      try {
        emit(
          StateLoadingSendEmailVerification(),
        );

        await _provider.sendVerificationEmail();

        devtools.log('EventSendEmailVerification: email has been sent');
        emit(
          StateSuccessfulSendEmailVerification(),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventSendEmailVerification: email hasn\'t been sent (CurrentUserNotFoundException)');
        emit(
          StateFailedSendEmailVerification(errorMessage: 'Verification mail could not be sent. Try again'),
        );
      } on GenericAuthModelException {
        devtools.log('EventSendEmailVerification: email hasn\'t been sent (GenericAuthModelException)');
        emit(
          StateFailedSendEmailVerification(errorMessage: 'Verification mail could not be sent. Try again'),
        );
      }

      devtools.log('EventSendEmailVerification finished');
    });

    on<EventLogout>((event, emit) async {
      devtools.log('EventLogout: started');
      try {
        emit(
          StateLoadingLogout(),
        );

        await _provider.logout();

        devtools.log('EventLogout: user logged out');
        emit(
          StateSuccessfulLogout(),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventLogout: not logged out (CurrentUserNotFoundException)');
        emit(
          StateFailedLogout(errorMessage: 'The user could not be found'),
        );
      } on GenericAuthModelException {
        devtools.log('EventLogout: not logged out (GenericAuthModelException)');
        emit(
          StateFailedLogout(errorMessage: 'Something went wrong. Please try again'),
        );
      } on GenericUserModelException {
        devtools.log('EventLogout: not logged out (GenericUserModelException)');
        emit(
          StateFailedLogout(errorMessage: 'Something went wrong. Please try again'),
        );
      }
      devtools.log('EventLogout: finished');
    });

    on<EventIsUserSignedIn>((event, emit) async {
      devtools.log('EventIsUserSignedIn: started');
      try {
        emit(
          StateLoadingIsUserSignedIn(),
        );

        bool isUserSignedIn = await _provider.isAnyUserSignedIn;
        await Future.delayed(
          const Duration(seconds: 3),
        );

        if (isUserSignedIn) {
          devtools.log('EventIsUserSignedIn: user signed in');
          emit(
            StateTrueUserSignedIn(),
          );
        } else {
          devtools.log('EventIsUserSignedIn: user not signed in');
          emit(
            StateFalseUserSignedIn(),
          );
        }
      } on GenericAuthModelException {
        devtools.log('EventIsUserSignedIn: user not signed in (GenericAuthModelException)');
      }
      devtools.log('EventIsUserSignedIn: finished');
    });

    on<EventDeleteUser>((event, emit) async {
      devtools.log('EventDeleteUser: started');
      try {
        emit(
          StateLoadingDeleteUser(),
        );

        String userPassword = event.password;
        await _provider.deleteCurrentUser(password: userPassword);

        emit(
          StateSuccessfulDeleteUser(),
        );
      } on RequiresRecentLoginException {
        devtools.log('EventDeleteUser: RequiresRecentLoginException');
        emit(
          StateFailedDeleteUser(
            errorMessage: 'kullanici giris yapmamis',
          ),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventDeleteUser: CurrentUserNotFoundException');
        emit(
          StateFailedDeleteUser(
            errorMessage: 'gecerli kullanici bulunamadi',
          ),
        );
      } on GenericAuthModelException {
        devtools.log('EventDeleteUser: GenericAuthModelException');
        emit(
          StateFailedDeleteUser(errorMessage: 'bir hata olustu'),
        );
      } on Exception catch (e) {
        devtools.log('EventDeleteUser: Exception');
        emit(
          StateFailedDeleteUser(
            errorMessage: e.toString(),
          ),
        );
      }
      devtools.log('EventDeleteUser: finished');
    });
  }
}
