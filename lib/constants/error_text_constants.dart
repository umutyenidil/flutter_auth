import 'package:flutter_auth/constants/regular_expression_warning_text_constants.dart';

class ErrorTextConstants {
  static String emptyErrorText = '';
  static const String emailAddressInputFieldErrorText = 'Please enter a valid e-mail address.';
  static String passwordInputFieldErrorText = RegularExpressionWarningTextConstants.min8Char(fieldName: 'Password');
  static const String passwordAgainInputFieldErrorText = 'Passwords do not match';
  static String usernameInputFieldErrorText = RegularExpressionWarningTextConstants.min8CharacterWithJustLettersAndNumbers(fieldName: 'Username');

}
