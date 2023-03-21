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
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/extensions/single_child_scroll_view_extensions.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/page_background.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_in_text_button.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_up_form_background.dart';
import 'package:flutter_auth/common_widgets/social_media_svg_button.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_up_material_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _mailInputController;
  late final TextEditingController _usernameInputController;
  late final TextEditingController _passwordInputController;
  late final TextEditingController _passwordAgainInputController;

  late final FocusNode _mailInputNode;
  late final FocusNode _usernameInputNode;
  late final FocusNode _passwordInputNode;
  late final FocusNode _passwordAgainInputNode;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateSignUpSuccess) {
          await PopUpMessage.success(
            title: 'İşlem Başarılı',
            message: 'Hesabınız başarıyla oluşturuldu.',
          ).show(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.signInPageRoute,
            (route) => false,
          );
        }
        if (state is AuthStateSignUpFailed) {
          if (state.exception is UserEmailAlreadyInUseException) {
            await PopUpMessage.danger(
              title: 'Email Hatası',
              message: 'Email başka bir kullanıcı tarafından kullanılıyor.',
            ).show(context).then((value) => null);
          }
          if (state.exception is UserInvalidEmailException) {
            await PopUpMessage.danger(
              title: 'Email Hatası',
              message: 'Kullandığınız email geçersizdir.',
            ).show(context);
          }
          if (state.exception is UserOperationNotAllowedException) {
            await PopUpMessage.danger(
              title: 'İzin Hatası',
              message: 'Lütfen yöneticilerle iletişime geçiniz.',
            ).show(context);
          }
          if (state.exception is UserWeakPasswordException) {
            await PopUpMessage.danger(
              title: 'Parola Hatası',
              message: 'Daha güçlü bir parola deneyiniz.',
            ).show(context);
          }
          if (state.exception is UserGenericException) {
            await PopUpMessage.danger(
              title: 'Beklenmedik Bir Hata',
              message: state.exception.toString(),
            ).show(context);
          }
        }
        if (state is AuthStateSignUpLoading) {
          const PopUpLoading().show(context);
        }
      },
      listenWhen: (previous, current) {
        if (previous is AuthStateSignUpLoading && current is! AuthStateSignUpLoading) {
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
                              'Already have an account?',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SignInTextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteConstants.signInPageRoute,
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
                                    'Getting started',
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
                                    'Create account to continue!',
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
                                  regularExpression: RegularExpressionConstants.min8CharacterRegex,
                                  inputType: TextInputType.text,
                                  hintText: 'Parolanızı giriniz',
                                  errorMessage: ErrorMessageConstants.passwordInputFieldErrorMessage,
                                  getValue: (String value) {
                                    setState(() {
                                      _passwordInputController.text = value;
                                    });
                                  },
                                ),
                                SecureInputField(
                                  node: _passwordAgainInputNode,
                                  svgIcon: IconPathConstants.lockIcon,
                                  regularExpression: RegularExpressionConstants.toRegex(_passwordInputController.text),
                                  inputType: TextInputType.text,
                                  hintText: 'Parolanızı tekrar giriniz',
                                  errorMessage: ErrorMessageConstants.passwordAgainInputFieldErrorMessage,
                                  getValue: (String value) {
                                    _passwordAgainInputController.text = value;
                                  },
                                ),
                                SignUpMaterialButton(
                                  onPressed: () async {
                                    String emailAddress = _mailInputController.text;
                                    String password = _passwordInputController.text;
                                    String passwordAgain = _passwordAgainInputController.text;
                                    if (emailAddress != StringErrorConstants.error && password != StringErrorConstants.error && passwordAgain != StringErrorConstants.error) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        AuthEventSignUpWithEmailAndPassword(
                                          context: context,
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
    _usernameInputController = TextEditingController();
    _passwordInputController = TextEditingController();
    _passwordAgainInputController = TextEditingController();

    _mailInputController.text = StringErrorConstants.error;
    _usernameInputController.text = StringErrorConstants.error;
    _passwordInputController.text = StringErrorConstants.error;
    _passwordAgainInputController.text = StringErrorConstants.error;

    _mailInputNode = FocusNode();
    _usernameInputNode = FocusNode();
    _passwordInputNode = FocusNode();
    _passwordAgainInputNode = FocusNode();
  }

  @override
  void dispose() {
    _mailInputController.dispose();
    _usernameInputController.dispose();
    _passwordInputController.dispose();
    _passwordAgainInputController.dispose();

    _mailInputNode.dispose();
    _usernameInputNode.dispose();
    _passwordInputNode.dispose();
    _passwordAgainInputNode.dispose();

    super.dispose();
  }
}
