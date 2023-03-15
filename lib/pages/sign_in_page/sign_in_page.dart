import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/error_message_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/constants/string_error_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/input_field.dart';
import 'package:flutter_auth/common_widgets/secure_input_field.dart';
import 'package:flutter_auth/common_widgets/social_media_svg_button.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/page_background.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_up_text_button.dart';
import 'package:flutter_auth/pages/sign_in_page/widgets/sign_in_form_background.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

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
                            SizedBox(
                              height: 54,
                              width: double.infinity,
                              child: MaterialButton(
                                color: Colors.blue,
                                minWidth: 0,
                                height: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusConstants.allCorners10,
                                ),
                                onPressed: () {
                                  print(_mailInputController.text);
                                  print(_passwordInputController.text);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
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
      ),
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
