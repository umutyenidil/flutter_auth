import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';
import 'package:flutter_auth/models/auth_model.dart';
import 'package:flutter_auth/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _provider = AuthService();

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
          StateFailedSignUpWithEmailAndPassword(error: 'Kullanici olusturulamadi'),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (CurrentUserNotFoundException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'kullanici olusturulamadi'),
        );
      } on EmailAlreadyInUseException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (EmailAlreadyInUseException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'email adresi kullanimda'),
        );
      } on InvalidEmailException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (InvalidEmailException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'gecersiz email adresi'),
        );
      } on OperationNotAllowedException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (OperationNotAllowedException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'operasyona izin verilmedi'),
        );
      } on WeakPasswordException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (WeakPasswordException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'daha guclu bir sifre deneyiniz'),
        );
      } on GenericAuthModelException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (GenericAuthModelException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'bir hata olustu'),
        );
      } on GenericUserModelException {
        devtools.log('EventSignUpWithEmailAndPassword: user not signed up (GenericUserModelException)');
        emit(
          StateFailedSignUpWithEmailAndPassword(error: 'bir hata olustu'),
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
          StateFailedSignInWithEmailAndPassword(error: 'gecersiz email'),
        );
      } on UserDisabledException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserDisabledException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'kullanici devredisi'),
        );
      } on UserNotFoundException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (UserNotFoundException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'kullanici bulunamadi'),
        );
      } on WrongPasswordException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (WrongPasswordException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'parola yanlis'),
        );
      } on CurrentUserNotFoundException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (CurrentUserNotFoundException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'gecerli kullanici bulunamadi'),
        );
      } on GenericUserModelException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (GenericUserModelException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'bir hata olustu'),
        );
      } on GenericAuthModelException {
        devtools.log('EventSignInWithEmailAndPassword: user not signed in (GenericAuthModelException)');
        emit(
          StateFailedSignInWithEmailAndPassword(error: 'bir hata olustu'),
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
            error: 'gecerli kullanici bulunamadi',
          ),
        );
      } on GenericAuthModelException {
        devtools.log('EventIsUserVerified: user not verified (unhandled exception)');
        emit(
          StateFailedIsUserVerified(
            error: 'bir hata olustu',
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
          StateFailedSendEmailVerification(error: 'kullanici bulunamadi'),
        );
      } on GenericAuthModelException {
        devtools.log('EventSendEmailVerification: email hasn\'t been sent (GenericAuthModelException)');
        emit(
          StateFailedSendEmailVerification(error: 'bir hata olustu'),
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
          StateFailedLogout(error: 'kullanici bulunamadi'),
        );
      } on GenericAuthModelException {
        devtools.log('EventLogout: not logged out (GenericAuthModelException)');
        emit(
          StateFailedLogout(error: 'bir hata olustu'),
        );
      } on GenericUserModelException {
        devtools.log('EventLogout: not logged out (GenericUserModelException)');
        emit(
          StateFailedLogout(error: 'bir hata olustu'),
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
  }
}
