class RegularExpressionWarningTextConstants {
  static String min8Char({required String fieldName}) {
    return '$fieldName must contain at least 8 characters';
  }

  static String min8CharacterWithJustLettersAndNumbers({required String fieldName}){
    return '$fieldName must contain at least 8 characters and it must consist only of letters and numbers';
  }

}
