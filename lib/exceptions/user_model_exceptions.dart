class UserModelExceptions implements Exception {}

class UserHasNotBeenCreatedException implements UserModelExceptions {}

class UserDocumentNotFoundException implements UserModelExceptions {}

class UserDetailDocumentNotFoundException implements UserModelExceptions {}

class UserEmailAlreadyInUseException implements UserModelExceptions {}

class UserInvalidEmailException implements UserModelExceptions {}

class UserOperationNotAllowedException implements UserModelExceptions {}

class UserWeakPasswordException implements UserModelExceptions {}

class UserGenericException implements UserModelExceptions {}
