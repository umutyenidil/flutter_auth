import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';

class AuthModel {
  AuthModel._privateConstructor();

  static final AuthModel instance = AuthModel._privateConstructor();

  Future<bool> signUpWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    late UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailAlreadyInUseException();
        case 'invalid-email':
          throw InvalidEmailException();
        case 'operation-not-allowed':
          throw OperationNotAllowedException();
        case 'weak-password':
          throw WeakPasswordException();
      }
    } on Exception catch (e) {
      throw GenericAuthModelException(
        exception: e,
      );
    }

    if (userCredential.user == null) {
      return false;
    }
    return true;
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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailException();
        case 'user-disabled':
          throw UserDisabledException();
        case 'user-not-found':
          throw UserNotFoundException();
        case 'wrong-password':
          throw WrongPasswordException();
      }
    } on Exception catch (e) {
      throw GenericAuthModelException(
        exception: e,
      );
    }
  }

  Future<bool> get isCurrentUserVerified async {
    User currentUser = await getCurrentUser();

    bool isCurrentUserVerified = currentUser.emailVerified;

    return isCurrentUserVerified;
  }

  Future<bool> get isAnyUserSignedIn async {
    try {
      await getCurrentUser();
      return true;
    } on CurrentUserNotFoundException {
      return false;
    } on Exception catch (e) {
      throw GenericAuthModelException(
        exception: e,
      );
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      throw GenericAuthModelException(
        exception: e,
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      User currentUser = await getCurrentUser();
      await currentUser.sendEmailVerification();
    } on CurrentUserNotFoundException {
      rethrow;
    } on Exception catch (e) {
      throw GenericAuthModelException(
        exception: e,
      );
    }
  }
}
