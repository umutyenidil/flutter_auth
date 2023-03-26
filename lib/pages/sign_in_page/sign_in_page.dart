import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
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
  late String _mailInputValue;
  late String _passwordInputValue;

  late final FocusNode _mailInputNode;
  late final FocusNode _passwordInputNode;

  @override
  void initState() {
    super.initState();

    _mailInputValue = StringErrorConstants.error;
    _passwordInputValue = StringErrorConstants.error;

    _mailInputNode = FocusNode();
    _passwordInputNode = FocusNode();
  }

  @override
  void dispose() {
    _mailInputNode.dispose();
    _passwordInputNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: listenerAuthBloc,
      listenWhen: listenWhenAuthBloc,
      builder: (context, state) {
        return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
          listener: listenerRemoteStorageBloc,
          listenWhen: listenWhenRemoteStorageBloc,
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
                                        _mailInputValue = value;
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
                                          _passwordInputValue = value;
                                        });
                                      },
                                    ),
                                    SignInMaterialButton(
                                      onPressed: () async {
                                        context.dismissKeyboard() ;

                                        if (_mailInputValue != StringErrorConstants.error && _passwordInputValue != StringErrorConstants.error) {
                                          BlocProvider.of<AuthBloc>(context).add(
                                            EventSignInWithEmailAndPassword(
                                              emailAddress: _mailInputValue,
                                              password: _passwordInputValue,
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
      },
    );
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateLoadingSignIn) {
      PopUpLoading().show(context);
    }
    if (state is StateSuccessfulSignIn) {
      await PopUpMessage.success(
        title: 'Islem Basarili',
        message: 'Basariyla giris yaptiniz. Yonlendiriliyorsunuz',
      ).show(context);

      BlocProvider.of<AuthBloc>(context).add(
        EventIsUserVerified(),
      );
    }
    if (state is StateFailedSignIn) {
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
    if (state is StateTrueIsUserVerified) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventIsUserProfileCreated(),
      );
    }
    if (state is StateFalseIsUserVerified) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteConstants.emailVerificationPageRoute,
        (route) => false,
      );
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (previous is StateLoadingSignIn && current is! StateLoadingSignIn) {
      Navigator.of(context).pop();
    }

    return true;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateLoadingIsUserProfileCreated) {
      PopUpLoading().show(context);
    }
    if (state is StateTrueUserProfileCreated) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteConstants.homePageRoute,
        (route) => false,
      );
    }
    if (state is StateFalseUserProfileCreated) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteConstants.createProfilePageRoute,
        (route) => false,
      );
    }
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (previous is StateLoadingIsUserProfileCreated && current is! StateLoadingIsUserProfileCreated) {
      Navigator.of(context).pop();
    }
    return true;
  }
}
