abstract class AuthModelException implements Exception {}

class GenericAuthModelException implements AuthModelException {
  final Exception _exception;

  GenericAuthModelException({required Exception exception}) : _exception = exception;

  Exception get exception => _exception;
}

class UserNotSignedUpException implements AuthModelException {}

class CurrentUserNotFoundException implements AuthModelException {}

class EmailAlreadyInUseException implements AuthModelException {}

class InvalidEmailException implements AuthModelException {}

class OperationNotAllowedException implements AuthModelException {}

class WeakPasswordException implements AuthModelException {}

class UserDisabledException implements AuthModelException {}

class UserNotFoundException implements AuthModelException {}

class WrongPasswordException implements AuthModelException {}
