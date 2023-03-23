import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/image_path_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/image_field.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/logout_button.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/send_email_verification_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateSendEmailVerificationLoading) {
          PopUpLoading().show(context);
        }

        if (state is AuthStateSendEmailVerificationSuccess) {
          await PopUpAcceptable(
            svgIcon: IconPathConstants.checkIcon,
            color: Colors.green,
            title: 'Verification Email',
            description: 'We sent your verification email.',
            leftButtonText: 'Cancel',
            leftButtonOnPressed: () {
              Navigator.of(context).pop();
            },
            rightButtonText: 'Open Mail App',
            rightButtonOnPressed: () async {
              OpenMailAppResult result = await OpenMailApp.openMailApp();
            },
          ).show(context);
          BlocProvider.of<AuthBloc>(context).add(
            AuthEventIsUserVerified(),
          );
        }

        if (state is AuthStateSendEmailVerificationFailed) {
          UserModelException exception = state.exception;
          if (exception is UserGenericException) {
            PopUpMessage.danger(
              title: 'Beklenmedik Bir Hata',
              message: exception.toString(),
            ).show(context);
          }
        }

        if (state is AuthStateIsUserVerifiedNotVerified) {
          await Future.delayed(Duration(seconds: 1));
          BlocProvider.of<AuthBloc>(context).add(
            AuthEventIsUserVerified(),
          );
        }

        if (state is AuthStateIsUserVerifiedVerified) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.profilePageRoute,
            (route) => false,
          );
        }
      },
      listenWhen: (previous, current) {
        if (previous is AuthStateSendEmailVerificationLoading && current is! AuthStateSendEmailVerificationLoading) {
          Navigator.of(context).pop();
        }

        return true;
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  bottom: 32,
                ),
                child: Column(
                  children: [
                    const ImageField(),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Verify your email.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const VerticalSpace(12),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'To create your profile and start using the app, you will need to verify your email address.',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const VerticalSpace(32),
                    SendEmailVerificationButton(
                      onPressed: () async {
                        BlocProvider.of<AuthBloc>(context).add(
                          AuthEventSendEmailVerification(),
                        );
                      },
                    ),
                    const Spacer(),
                    LogoutButton(
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
