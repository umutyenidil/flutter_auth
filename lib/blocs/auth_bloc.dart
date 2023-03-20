import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_auth/common_widgets/pop_up_message.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEventSignUpWithEmailAndPassword>((event, emit) async {
      try {
        await UserModel().signUpWithEmailAndPassword(
          emailAddress: event.emailAddress,
          password: event.password,
        );

        await PopUp(
          title: 'İşlem Başarılı',
          message: 'Hesabınız başarıyla oluşturuldu.',
          type: PopUpMessageType.success,
        ).show(event.context);
        Navigator.of(event.context).pushNamedAndRemoveUntil(
          RouteConstants.signInPageRoute,
          (route) => false,
        );
      } on UserEmailAlreadyInUseException {
        PopUp(
          type: PopUpMessageType.danger,
          title: 'Email Hatası',
          message: 'Email başka bir kullanıcı tarafından kullanılıyor.',
        ).show(event.context);
      } on UserInvalidEmailException {
        PopUp(
          type: PopUpMessageType.danger,
          title: 'Email Hatası',
          message: 'Kullandığınız email geçersizdir.',
        ).show(event.context);
      } on UserOperationNotAllowedException {
        PopUp(
          type: PopUpMessageType.danger,
          title: 'İzin Hatası',
          message: 'Lütfen yöneticilerle iletişime geçiniz.',
        ).show(event.context);
      } on UserWeakPasswordException {
        PopUp(
          type: PopUpMessageType.danger,
          title: 'Parola Hatası',
          message: 'Daha güçlü bir parola deneyiniz.',
        ).show(event.context);
      } catch (exception) {
        PopUp(
          type: PopUpMessageType.danger,
          title: 'Beklenmedik Bir Hata',
          message: exception.toString(),
        ).show(event.context);
      }
    });
  }
}
