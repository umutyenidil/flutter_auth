import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/models/auth_model.dart';

class AuthService {
  Future<bool> signUpWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      bool? isUserSignedUp = await AuthModel().signUpWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      if (!(isUserSignedUp!)) {
        throw UserNotSignedUpException();
      }

      User currentUser = await AuthModel().getCurrentUser();

      bool? isUserCreated = await UserModel().create(
        uid: currentUser.uid,
        emailAddress: emailAddress,
      );

      return isUserCreated!;
    } on UserNotSignedUpException {
      rethrow;
    } on CurrentUserNotFoundException {
      rethrow;
    } on EmailAlreadyInUseException {
      rethrow;
    } on InvalidEmailException {
      rethrow;
    } on OperationNotAllowedException {
      rethrow;
    } on WeakPasswordException {
      rethrow;
    } on GenericAuthModelException {
      rethrow;
    } on GenericUserModelException {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await AuthModel().signInWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      User currentUser = await AuthModel().getCurrentUser();

      await UserModel().updateWithUid(
        uid: currentUser.uid,
        data: {
          UserModelFieldsEnum.lastLogin: FieldValue.serverTimestamp(),
        },
      );
    } on InvalidEmailException {
      rethrow;
    } on UserDisabledException {
      rethrow;
    } on UserNotFoundException {
      rethrow;
    } on WrongPasswordException {
      rethrow;
    } on CurrentUserNotFoundException {
      rethrow;
    } on GenericUserModelException {
      rethrow;
    } on GenericAuthModelException {
      rethrow;
    }
  }

  Future<bool> isCurrentUserVerified() async {
    try {
      bool isVerified = await AuthModel().isCurrentUserVerified();
      return isVerified;
    } on CurrentUserNotFoundException {
      rethrow;
    } on GenericAuthModelException {
      rethrow;
    }
  }
}
