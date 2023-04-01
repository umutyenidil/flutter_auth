abstract class UserModelException implements Exception {}

class GenericUserModelException implements UserModelException {
  final String _exception;

  GenericUserModelException({required String exception}) : _exception = exception;

  String get exception => _exception;
}

class UserHasNotBeenCreatedException implements UserModelException {}

class UserDidntSignInException implements UserModelException {}

class UserDocumentNotFoundException implements UserModelException {}

class UserDetailDocumentNotFoundException implements UserModelException {}




class UserCannotReadFromCloudException implements UserModelException {}
