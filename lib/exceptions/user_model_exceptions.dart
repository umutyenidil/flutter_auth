abstract class UserModelException implements Exception {}

class GenericUserModelException implements UserModelException {
  final String _exception;

  GenericUserModelException({required String methodName}) : _exception = methodName;

  String get methodName => _exception;
}

class UsersNotFetchedException implements UserModelException {}

class UserNotUpdatedException implements UserModelException {}

class UniqueFieldException implements UserModelException {
  final String fieldName;

  UniqueFieldException({required this.fieldName});
}

class UserNotDeletedException implements UserModelException {}
