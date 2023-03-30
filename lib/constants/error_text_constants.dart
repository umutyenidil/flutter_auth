import 'package:flutter_auth/constants/regular_expression_warning_text_constants.dart';

class ErrorTextConstants {
  static const String emailAddressInputFieldErrorText = 'Please enter a valid e-mail address.';
  static String passwordInputFieldErrorText = RegularExpressionWarningTextConstants.min8CharWarningText(fieldName: 'Password');
  static const String passwordAgainInputFieldErrorText = 'Passwords do not match';

  static const String usernameInputFieldErrorText = 'Kullanıcı adı minimum 8 karakterden oluşup sadece rakam ve harf içermelidir.';
}
