import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/common_widgets/app_logo.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/text_divider.dart';
import 'package:flutter_auth/constants/error_text_constants.dart';
import 'package:flutter_auth/constants/hint_text_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/page_container.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_in_button.dart';
import 'package:flutter_auth/common_widgets/social_media_svg_button.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_up_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late InputFieldValue _emailAddressInputValue;
  late SecureInputFieldValue _passwordInputValue;
  late SecureInputFieldValue _passwordAgainInputValue;

  late final FocusNode _emailAddressInputNode;
  late final FocusNode _usernameInputNode;
  late final FocusNode _passwordInputNode;
  late final FocusNode _passwordAgainInputNode;

  @override
  void initState() {
    super.initState();

    _emailAddressInputValue = InputFieldValue(
      value: '',
      status: InputFieldStatusEnum.empty,
    );
    _passwordInputValue = SecureInputFieldValue(
      value: '',
      status: SecureInputFieldStatusEnum.empty,
    );
    _passwordAgainInputValue = SecureInputFieldValue(
      value: '',
      status: SecureInputFieldStatusEnum.empty,
    );

    _emailAddressInputNode = FocusNode();
    _usernameInputNode = FocusNode();
    _passwordInputNode = FocusNode();
    _passwordAgainInputNode = FocusNode();
  }

  @override
  void dispose() {
    _emailAddressInputNode.dispose();
    _usernameInputNode.dispose();
    _passwordInputNode.dispose();
    _passwordAgainInputNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: listenerAuthBloc,
      listenWhen: listenWhenAuthBloc,
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
                            'Sign up',
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
                          inputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          regularExpression: RegularExpressionConstants.emailAddress,
                          hintText: HintTextConstants.emailAddressInputFieldHintText,
                          errorMessage: ErrorTextConstants.emailAddressInputFieldErrorText,
                          svgIcon: IconPathConstants.mailIcon,
                          getValue: (InputFieldValue value) {
                            _emailAddressInputValue = value;
                          },
                        ),
                        SecureInputField(
                          node: _passwordInputNode,
                          nextNode: _passwordAgainInputNode,
                          inputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          regularExpression: RegularExpressionConstants.min8Char,
                          hintText: HintTextConstants.passwordInputFieldHintText,
                          errorMessage: ErrorTextConstants.passwordInputFieldErrorText,
                          svgIcon: IconPathConstants.lockIcon,
                          getValue: (SecureInputFieldValue value) {
                            _passwordInputValue = value;
                          },
                        ),
                        SecureInputField(
                          node: _passwordAgainInputNode,
                          inputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          regularExpression: RegularExpressionConstants.toRegex(_passwordInputValue.value),
                          hintText: HintTextConstants.passwordAgainInputFieldHintText,
                          errorMessage: ErrorTextConstants.passwordAgainInputFieldErrorText,
                          svgIcon: IconPathConstants.lockIcon,
                          getValue: (SecureInputFieldValue value) {
                            setState(() {
                              _passwordAgainInputValue = value;
                            });
                          },
                        ),
                        SignUpButton(
                          onPressed: _signUpButtonFunction,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                            const HorizontalSpace(12),
                            SignInButton(
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 13,
                              onPressed: _signInButtonFunction,
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
  }

  Future<void> _signUpButtonFunction() async {
    context.dismissKeyboard();
    if (_emailAddressInputValue.status == InputFieldStatusEnum.empty) {
      await PopUpMessage.warning(
        title: 'Email address error',
        message: 'Email address field cannot be left empty',
      ).show(context);
      return;
    }
    if (_emailAddressInputValue.status == InputFieldStatusEnum.notMatched) {
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
    if (_passwordAgainInputValue.status == SecureInputFieldStatusEnum.empty) {
      await PopUpMessage.warning(
        title: 'Password error',
        message: 'Enter the password again',
      ).show(context);
      return;
    }
    if (_passwordInputValue.status == SecureInputFieldStatusEnum.notMatched) {
      await PopUpMessage.warning(
        title: 'Password error',
        message: 'The entered passwords do not match',
      ).show(context);
      return;
    }
    BlocProvider.of<AuthBloc>(context).add(
      EventSignUpWithEmailAndPassword(
        emailAddress: _emailAddressInputValue.value,
        password: _passwordInputValue.value,
      ),
    );
  }

  void _signInButtonFunction() {
    context.pageTransitionSlide(
      page: const SignInPage(),
      direction: PageTransitionDirection.topToBottom,
    );
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateSuccessfulSignUpWithEmailAndPassword) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'You have signed up',
          message: 'You are being redirected to the sign in page',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const SignInPage(),
        );
      }
      return;
    }

    if (state is StateFailedSignUpWithEmailAndPassword) {
      await context.delayedPop();
      if (context.mounted) {
        Exception exception = state.exception;
        if (exception is UserEmailAlreadyInUseException) {
          await PopUpMessage.danger(
            title: 'Email address error',
            message: 'the email address has already been taken by someone else',
          ).show(context);
          return;
        }
        if (exception is UserInvalidEmailException) {
          await PopUpMessage.danger(
            title: 'Email address error',
            message: 'Please enter a valid email address',
          ).show(context);
          return;
        }
        if (exception is UserOperationNotAllowedException) {
          await PopUpMessage.danger(
            title: 'User error',
            message: 'Something went wrong, get in touch with your managers',
          ).show(context);
          return;
        }
        if (exception is UserWeakPasswordException) {
          await PopUpMessage.danger(
            title: 'Password error',
            message: 'Please use a stronger password',
          ).show(context);
          return;
        }
        if (exception is UserGenericException) {
          await PopUpMessage.danger(
            title: 'Unexpected error',
            message: 'An unexpected error has occurred',
          ).show(context);
          return;
        }
      }
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (current is StateLoadingSignUpWithEmailAndPassword) {
      const PopUpLoading().show(context);
      return false;
    }
    return true;
  }
}
