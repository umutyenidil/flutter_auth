class UserModelException implements Exception {}

class UserHasNotBeenCreatedException implements UserModelException {}

class UserDidntSignInException implements UserModelException {}

class UserDocumentNotFoundException implements UserModelException {}

class UserDetailDocumentNotFoundException implements UserModelException {}

class UserEmailAlreadyInUseException implements UserModelException {}

class UserInvalidEmailException implements UserModelException {}

class UserOperationNotAllowedException implements UserModelException {}

class UserWeakPasswordException implements UserModelException {}

class UserDisabledException implements UserModelException {}

class UserNotFoundException implements UserModelException {}

class UserWrongPasswordException implements UserModelException {}

class UserGenericException implements UserModelException {}

class CurrentUserNotFoundException implements UserModelException {}

class UserCannotReadFromCloudException implements UserModelException {}
