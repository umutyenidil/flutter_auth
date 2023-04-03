abstract class RemoteStorageException implements Exception {}

class GenericRemoteStorageException implements RemoteStorageException {
  final String _exception;

  GenericRemoteStorageException({required String exception}) : _exception = exception;

  String get exception => _exception;
}
