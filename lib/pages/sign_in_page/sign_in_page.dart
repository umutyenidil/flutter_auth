import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/constants/error_message_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/constants/string_error_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/common_widgets/social_media_svg_button.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/extensions/single_child_scroll_view_extensions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/page_background.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_in_material_button.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_up_text_button.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_in_form_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _mailInputController;
  late final TextEditingController _passwordInputController;

  late final FocusNode _mailInputNode;
  late final FocusNode _passwordInputNode;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateSignInSuccess) {
          await PopUpMessage.success(
            title: 'Islem Basarili',
            message: 'Basariyla giris yaptiniz. Yonlendiriliyorsunuz',
          ).show(context);

          BlocProvider.of<AuthBloc>(context).add(
            AuthEventIsUserVerified(),
          );
        }
        if (state is AuthStateSignInLoading) {
          PopUpLoading().show(context);
        }

        if (state is AuthStateIsUserVerifiedVerified) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.profilePageRoute,
            (route) => false,
          );
        } else if (state is AuthStateIsUserVerifiedNotVerified) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.emailVerificationPageRoute,
            (route) => false,
          );
        }

        if (state is AuthStateSignInFailed) {
          UserModelException exception = state.exception;
          if (exception is UserInvalidEmailException) {
            await PopUpMessage.danger(
              title: 'Email Hatası',
              message: 'Lütfen geçerli bir email adresi giriniz.',
            ).show(context);
          }
          if (exception is UserDisabledException) {
            await PopUpMessage.danger(
              title: 'Kullanıcı Hatası',
              message: 'Hesabınız dondurulmuştur. Lütfen yöneticilerle iletişime geçiniz.',
            ).show(context);
          }
          if (exception is UserNotFoundException) {
            await PopUpMessage.danger(
              title: 'Kullanıcı Hatası',
              message: 'Email adresiniz veya parolanız hatalıdır. Lütfen kontrol ediniz.',
            ).show(context);
          }
          if (exception is UserWrongPasswordException) {
            await PopUpMessage.danger(
              title: 'Kullanici Hatasi',
              message: 'Email adresiniz veya parolanız hatalıdır. Lütfen kontrol ediniz.',
            ).show(context);
          }
          if (exception is UserDidntSignInException) {
            await PopUpMessage.danger(
              title: 'Oturum Açma Hatası',
              message: 'Oturum açılamadı. Tekrar deneyiniz.',
            ).show(context);
          }
          if (exception is UserGenericException) {
            await PopUpMessage.danger(
              title: 'Beklenmedik Bir Hata',
              message: exception.toString(),
            ).show(context);
          }
        }
      },
      listenWhen: (previous, current) {
        if (previous is AuthStateSignInLoading && current is! AuthStateSignInLoading) {
          Navigator.of(context).pop();
        }

        return true;
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: PageBackground(
              child: SizedBox(
                width: context.screenWidth,
                height: context.screenHeight,
                child: SafeArea(
                  child: Column(
                    children: [
                      const VerticalSpace(8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            BackSvgButton(
                              onPressed: () {},
                            ),
                            const Spacer(),
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SignUpTextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteConstants.signUpPageRoute,
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(32),
                      Expanded(
                        child: SignUpFormBackground(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const VerticalSpace(26),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Let\'s get something',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const VerticalSpace(8),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Good to see you back.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const VerticalSpace(22),
                                Row(
                                  children: [
                                    context.selectWidgetByPlatform(
                                      androidWidget: SocialMediaSvgButton.google(onPressed: () {}),
                                      iosWidget: SocialMediaSvgButton.apple(onPressed: () {}),
                                    ),
                                    const HorizontalSpace(16),
                                    SocialMediaSvgButton.facebook(onPressed: () {}),
                                    const HorizontalSpace(16),
                                    SocialMediaSvgButton.twitter(onPressed: () {}),
                                  ],
                                ),
                                const VerticalSpace(36),
                                InputField(
                                  node: _mailInputNode,
                                  svgIcon: IconPathConstants.mailIcon,
                                  regularExpression: RegularExpressionConstants.emailRegex,
                                  inputType: TextInputType.emailAddress,
                                  hintText: 'Email adresinizi giriniz',
                                  errorMessage: ErrorMessageConstants.emailInputFieldErrorMessage,
                                  getValue: (String value) {
                                    _mailInputController.text = value;
                                  },
                                ),
                                SecureInputField(
                                  node: _passwordInputNode,
                                  svgIcon: IconPathConstants.lockIcon,
                                  regularExpression: RegularExpressionConstants.min8CharacterWithAnythingRegex,
                                  inputType: TextInputType.text,
                                  hintText: 'Parolanizi giriniz',
                                  errorMessage: ErrorMessageConstants.passwordInputFieldErrorMessage2,
                                  getValue: (String value) {
                                    setState(() {
                                      _passwordInputController.text = value;
                                    });
                                  },
                                ),
                                SignInMaterialButton(
                                  onPressed: () async {
                                    String emailAddress = _mailInputController.text;
                                    String password = _passwordInputController.text;
                                    if (emailAddress != StringErrorConstants.error && password != StringErrorConstants.error) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        AuthEventSignInWithEmailAndPassword(
                                          emailAddress: emailAddress,
                                          password: password,
                                        ),
                                      );
                                    } else {
                                      await PopUpMessage.warning(
                                        title: 'Alanlar Hatalı',
                                        message: 'Lütfen alanlardaki hataları düzeltin.',
                                      ).show(context);
                                    }
                                  },
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot your password?',
                                    style: TextStyle(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).removeScrollGlow(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _mailInputController = TextEditingController();
    _passwordInputController = TextEditingController();

    _mailInputController.text = StringErrorConstants.error;
    _passwordInputController.text = StringErrorConstants.error;

    _mailInputNode = FocusNode();
    _passwordInputNode = FocusNode();
  }

  @override
  void dispose() {
    _mailInputController.dispose();
    _passwordInputController.dispose();

    _mailInputNode.dispose();
    _passwordInputNode.dispose();

    super.dispose();
  }
}
