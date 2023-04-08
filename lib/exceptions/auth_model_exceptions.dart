abstract class AuthModelException implements Exception {}

class GenericAuthModelException implements AuthModelException {
  final String _methodName;

  GenericAuthModelException({required String methodName}) : _methodName = methodName;

  String get methodName => _methodName;
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

class RequiresRecentLoginException implements AuthModelException {}
