import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/pages/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/pages/common_widgets/vertical_space.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/back_svg_button.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/input_field.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/page_background.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_in_text_button.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/sign_up_form_background.dart';
import 'package:flutter_auth/pages/sign_up_page/widgets/social_media_svg_button.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

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
    return Scaffold(
      body: SingleChildScrollView(
        child: PageBackground(
          child: SizedBox(
            width: context.screenWidth,
            height: context.screenHeight,
            child: SafeArea(
              child: Column(
                children: [
                  VerticalSpace(8),
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
                        SignInTextButton(onPressed: () {}),
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
                              controller: _mailInputController,
                              svgIcon: IconPathConstants.mailIcon,
                              regularExpression: RegularExpressionConstants.emailRegex,
                              inputType: TextInputType.emailAddress,
                              hintText: 'Email adresinizi giriniz',
                              errorMessage: 'Lütfen geçerli bir email adresi giriniz.',
                            ),
                            VerticalSpace(40),
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
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
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
    _usernameInputController = TextEditingController();
    _passwordInputController = TextEditingController();
    _passwordAgainInputController = TextEditingController();

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
