import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/app_logo.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/text_divider.dart';
import 'package:flutter_auth/constants/error_text_constants.dart';
import 'package:flutter_auth/constants/hint_text_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/common_widgets/social_media_svg_button.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/input_values/input_field_value.dart';
import 'package:flutter_auth/pages/email_verification_page/email_verification_page.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_create_page/profile_create_page.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/forgot_your_password_button.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/page_container.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_in_button.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_up_button.dart';
import 'package:flutter_auth/pages/sign_up_page/sign_up_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  InputFieldValue? _emailAddressInputValue;
  late SecureInputFieldValue _passwordInputValue;

  late final FocusNode _emailAddressInputNode;
  late final FocusNode _passwordInputNode;

  @override
  void initState() {
    super.initState();

    _passwordInputValue = SecureInputFieldValue(
      value: '',
      status: SecureInputFieldStatusEnum.empty,
    );

    _emailAddressInputNode = FocusNode();
    _passwordInputNode = FocusNode();
  }

  @override
  void dispose() {
    _emailAddressInputNode.dispose();
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
              body: PageContainer(
                content: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 40.0,
                      ),
                      child: AppLogo(),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const VerticalSpace(16),
                            const TextDivider(
                              fontSize: 12,
                              text: 'With Social',
                              textColor: Colors.grey,
                            ),
                            const VerticalSpace(12),
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
                            const VerticalSpace(24),
                            const TextDivider(
                              fontSize: 12,
                              text: 'With Email',
                              textColor: Colors.grey,
                            ),
                            const VerticalSpace(12),
                            InputField(
                              node: _emailAddressInputNode,
                              nextNode: _passwordInputNode,
                              textInputAction: TextInputAction.next,
                              inputType: TextInputType.emailAddress,
                              regularExpression: RegularExpressionConstants.emailAddress,
                              hintText: HintTextConstants.emailAddressInputFieldHintText,
                              errorMessage: ErrorTextConstants.emailAddressInputFieldErrorText,
                              svgIcon: IconPathConstants.mailIcon,
                              getValue: (InputFieldValue? value) {
                                _emailAddressInputValue = value;
                              },
                            ),
                            SecureInputField(
                              node: _passwordInputNode,
                              regularExpression: RegularExpressionConstants.min8Char,
                              textInputAction: TextInputAction.done,
                              inputType: TextInputType.text,
                              hintText: HintTextConstants.passwordInputFieldHintText,
                              errorMessage: ErrorTextConstants.passwordInputFieldErrorText,
                              svgIcon: IconPathConstants.lockIcon,
                              getValue: (SecureInputFieldValue value) {
                                _passwordInputValue = value;
                              },
                            ),
                            const VerticalSpace(16),
                            SignInButton(
                              onPressed: _signInButtonFunction,
                            ),
                            ForgotYourPasswordButton(
                              onPressed: () {},
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                  ),
                                ),
                                const HorizontalSpace(12),
                                SignUpButton(
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 13,
                                  onPressed: _signUpButtonFunction,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _signUpButtonFunction() {
    context.pageTransitionSlide(
      page: const SignUpPage(),
      direction: PageTransitionDirection.bottomToTop,
    );
  }

  Future<void> _signInButtonFunction() async {
    context.dismissKeyboard();
    if (_emailAddressInputValue == null) {
      await PopUpMessage.warning(
        title: 'Email address error',
        message: 'Email address field cannot be left empty',
      ).show(context);
      return;
    }
    if (_emailAddressInputValue!.status == InputFieldStatusEnum.notMatched) {
      await PopUpMessage.warning(
        title: 'Email address error',
        message: 'There is an error in the email address field',
      ).show(context);
      return;
    }
    if (_passwordInputValue.status == SecureInputFieldStatusEnum.empty) {
      await PopUpMessage.warning(
        title: 'Password error',
        message: 'Password field cannot be left empty',
      ).show(context);
      return;
    }
    if (_passwordInputValue.status == SecureInputFieldStatusEnum.notMatched) {
      await PopUpMessage.warning(
        title: 'Password error',
        message: 'There is an error in the password field',
      ).show(context);
      return;
    }

    BlocProvider.of<AuthBloc>(context).add(
      EventSignInWithEmailAndPassword(
        emailAddress: _emailAddressInputValue!.value,
        password: _passwordInputValue.value,
      ),
    );
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateFailedSignInWithEmailAndPassword) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.danger(
          title: 'bir seyler ters gitt',
          message: state.error,
        ).show(context);
      }
      return;
    }

    if (state is StateFalseUserVerified) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'You have been logged in',
          message: 'You are being redirected to the verification page',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const EmailVerificationPage(),
        );
      }
      return;
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (current is StateLoadingSignInWithEmailAndPassword) {
      const PopUpLoading().show(context);
      return false;
    }
    if (previous is StateLoadingSignInWithEmailAndPassword && current is StateSuccessfulSignInWithEmailAndPassword) {
      BlocProvider.of<AuthBloc>(context).add(
        EventIsUserVerified(),
      );
      return false;
    }
    if (previous is StateLoadingIsUserVerified && current is StateTrueUserVerified) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventIsUserProfileCreated(),
      );
      return false;
    }
    return true;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateTrueUserProfileCreated) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'You have been logged in',
          message: 'You are being redirected to the home page',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const HomePage(),
        );
      }
      return;
    }
    if (state is StateFalseUserProfileCreated) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'You have been logged in',
          message: 'You are being redirected to the profile create page',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const ProfileCreatePage(),
        );
      }
      return;
    }
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (current is StateLoadingIsUserProfileCreated) {
      return false;
    }

    return true;
  }
}
