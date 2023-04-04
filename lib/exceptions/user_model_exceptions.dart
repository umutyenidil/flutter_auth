abstract class UserModelException implements Exception {}

class GenericUserModelException implements UserModelException {
  final Exception _exception;

  GenericUserModelException({required Exception exception}) : _exception = exception;

  Exception get exception => _exception;
}

class UsersNotFetchedException implements UserModelException {}

class UserNotUpdatedException implements UserModelException {}

class UniqueFieldException implements UserModelException {
  final String fieldName;

  UniqueFieldException({required this.fieldName});
}

class UserNotDeletedException implements UserModelException {}
