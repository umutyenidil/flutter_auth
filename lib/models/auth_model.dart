import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/exceptions/auth_model_exceptions.dart';

class AuthModel {
  AuthModel._privateConstructor();

  static final AuthModel instance = AuthModel._privateConstructor();

  /// email ve parola ile kullanici olusturur
  ///
  /// throws EmailAlreadyInUseException
  ///
  /// throws InvalidEmailException
  ///
  /// throws OperationNotAllowedException
  ///
  /// throws WeakPasswordException
  ///
  /// throws GenericAuthModelException
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
        methodName: 'signUpWithEmailAndPassword()',
      );
    }

    if (userCredential.user == null) {
      return false;
    }
    return true;
  }

  /// Oturum acmis kullanici dondurur
  ///
  /// throws GenericAuthModelException
  ///
  /// throws CurrentUserNotFoundException
  Future<User> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw CurrentUserNotFoundException();
    }

    try {
      await user.reload();
    } on Exception catch (e) {
      throw GenericAuthModelException(
        methodName: 'getCurrentUser()',
      );
    }

    return user;
  }

  /// email ve parola ile oturum acar
  ///
  /// throws InvalidEmailException
  ///
  /// throws UserDisabledException
  ///
  /// throws UserNotFoundException
  ///
  /// throws WrongPasswordException
  ///
  /// throws GenericAuthModelException
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
        methodName: 'signInWithEmailAndPassword()',
      );
    }
  }

  /// oturum acmis kullanicinin dogrulanip dogrulanmadigini gosterir
  ///
  /// throws CurrentUserNotFoundException
  ///
  /// throws GenericAuthModelException
  Future<bool> get isCurrentUserVerified async {
    late User currentUser;
    try {
      currentUser = await getCurrentUser();
    } on CurrentUserNotFoundException {
      rethrow;
    } on GenericAuthModelException {
      rethrow;
    }

    bool isCurrentUserVerified = currentUser.emailVerified;

    return isCurrentUserVerified;
  }

  /// herhangi bir kullanicinin signed in olup olmadigini kontrol eder
  ///
  /// throws GenericAuthModelException
  Future<bool> get isAnyUserSignedIn async {
    try {
      await getCurrentUser();
      return true;
    } on CurrentUserNotFoundException {
      return false;
    } on GenericAuthModelException {
      rethrow;
    }
  }

  /// gecerli kullanici icin cikis yapar
  ///
  /// throws GenericAuthModelException
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      throw GenericAuthModelException(
        methodName: 'logout()',
      );
    }
  }

  /// gecerli kullaniciya dogrulama maili gonderir
  ///
  /// throws CurrentUserNotFoundException
  ///
  /// throws GenericAuthModelException
  Future<void> sendVerificationEmail() async {
    try {
      User currentUser = await getCurrentUser();
      await currentUser.sendEmailVerification();
    } on CurrentUserNotFoundException {
      rethrow;
    } on GenericAuthModelException {
      rethrow;
    } on Exception catch (e) {
      throw GenericAuthModelException(
        methodName: 'sendVerificationEmail()',
      );
    }
  }

  /// gecerli kullaniciyi siler
  ///
  /// throws RequiresRecentLoginException
  ///
  /// throws CurrentUserNotFoundException
  ///
  /// throws GenericAuthModelException
  Future<void> delete() async {
    try {
      User currentUser = await getCurrentUser();
      await currentUser.delete();
    } on CurrentUserNotFoundException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw RequiresRecentLoginException();
      }
    } on GenericAuthModelException {
      rethrow;
    } on Exception {
      throw GenericAuthModelException(
        methodName: 'delete()',
      );
    }
  }
}
