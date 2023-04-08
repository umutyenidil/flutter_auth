abstract class AuthException implements Exception {}

class GenericAuthException implements AuthException {
  final String _methodName;

  GenericAuthException({required String methodName}) : _methodName = methodName;

  String get exception => _methodName;
}
