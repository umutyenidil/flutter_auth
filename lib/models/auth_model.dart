import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';

class AuthModel {
  static final AuthModel _shared = AuthModel._sharedInstance();

  AuthModel._sharedInstance();

  factory AuthModel() => _shared;

  Future<bool?> signUpWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (userCredential.user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'email-already-in-use':
          throw EmailAlreadyInUseException();
        case 'invalid-email':
          throw InvalidEmailException();
        case 'operation-not-allowed':
          throw OperationNotAllowedException();
        case 'weak-password':
          throw WeakPasswordException();
      }
    } catch (exception) {
      throw GenericAuthModelException(
        exception: exception.toString(),
      );
    }
    return null;
  }

  Future<User> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw CurrentUserNotFoundException();
    }

    await user.reload();

    return user;
  }

  Future<void> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'invalid-email':
          throw InvalidEmailException();
        case 'user-disabled':
          throw UserDisabledException();
        case 'user-not-found':
          throw UserNotFoundException();
        case 'wrong-password':
          throw WrongPasswordException();
      }
    } catch (exception) {
      throw GenericAuthModelException(exception: exception.toString());
    }
  }

  Future<bool> get isCurrentUserVerified async {
    try {
      User currentUser = await getCurrentUser();

      bool isVerified = currentUser.emailVerified;

      return isVerified;
    } on CurrentUserNotFoundException {
      rethrow;
    } catch (exception) {
      GenericAuthModelException(exception: exception.toString());
    }
    return false;
  }

  Future<bool> get isAnyUserSignedIn async {
    try {
      await getCurrentUser();
      return true;
    } on CurrentUserNotFoundException {
      return false;
    } catch (exception) {
      throw GenericAuthModelException(
        exception: exception.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (exception) {
      throw GenericAuthModelException(
        exception: exception.toString(),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      User currentUser = await getCurrentUser();
      await currentUser.sendEmailVerification();
    } on CurrentUserNotFoundException {
      rethrow;
    } catch (exception) {
      throw GenericAuthModelException(exception: exception.toString());
    }
  }
}
