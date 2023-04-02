abstract class UserModelException implements Exception {}

class GenericUserModelException implements UserModelException {
  final String _exception;

  GenericUserModelException({required String exception}) : _exception = exception;

  String get exception => _exception;
}
