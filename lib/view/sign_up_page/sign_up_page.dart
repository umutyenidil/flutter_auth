import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/regular_expression_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/view/common_widgets/horizontal_space.dart';
import 'package:flutter_auth/view/common_widgets/vertical_space.dart';
import 'package:flutter_auth/view/sign_up_page/widgets/back_svg_button.dart';
import 'package:flutter_auth/view/sign_up_page/widgets/input_field.dart';
import 'package:flutter_auth/view/sign_up_page/widgets/page_background.dart';
import 'package:flutter_auth/view/sign_up_page/widgets/sign_in_text_button.dart';
import 'package:flutter_auth/view/sign_up_page/widgets/sign_up_form_background.dart';
import 'package:flutter_auth/view/sign_up_page/widgets/social_media_svg_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
                              svgIcon: IconPathConstants.mailIcon,
                              regularExpression: RegularExpressionConstants.emailRegex,
                              inputType: TextInputType.emailAddress,
                              hintText: 'Email adresinizi giriniz',
                              node: FocusNode(),
                              errorMessage: 'Lutfen gecerli bir email adresi giriniz',
                            ),
                            const VerticalSpace(8),
                            InputField(
                              svgIcon: IconPathConstants.userIcon,
                              regularExpression: RegularExpressionConstants.min8CharacterRegex,
                              inputType: TextInputType.emailAddress,
                              hintText: 'Email adresinizi giriniz',
                              node: FocusNode(),
                              errorMessage: 'Lutfen gecerli bir email adresi giriniz',
                            ),
                            const VerticalSpace(8),
                            InputField(
                              svgIcon: IconPathConstants.lockIcon,
                              regularExpression: RegularExpressionConstants.min8CharacterRegex,
                              inputType: TextInputType.emailAddress,
                              hintText: 'Email adresinizi giriniz',
                              node: FocusNode(),
                              errorMessage: 'Lutfen gecerli bir email adresi giriniz',
                            ),
                            const VerticalSpace(8),
                            InputField(
                              svgIcon: IconPathConstants.lockIcon,
                              regularExpression: RegularExpressionConstants.min8CharacterRegex,
                              inputType: TextInputType.emailAddress,
                              hintText: 'Parolanizi tekrar giriniz',
                              node: FocusNode(),
                              errorMessage: 'Lutfen gecerli bir email adresi giriniz',
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
                                onPressed: () {},
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
}
