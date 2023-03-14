class RegularExpressionConstants {
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String min8CharacterRegex = r'^.{8,}$';
  static const String min8CharacterWithJustLettersAndNumbers = r'^[a-zA-Z0-9]{8,}$';

  static String toRegex(String text) {
    return '^$text\$';
  }
}
