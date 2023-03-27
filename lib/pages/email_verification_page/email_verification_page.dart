import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/pages/create_profile_page/create_profile_page.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/image_field.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/logout_button.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/send_email_verification_button.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      listener: listenerAuthBloc,
      listenWhen: listenWhenAuthBloc,
      builder: (context, state) {
        return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
          listener: listenerRemoteStorageBloc,
          listenWhen: listenWhenRemoteStorageBloc,
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
                              EventSendEmailVerification(),
                            );
                          },
                        ),
                        const Spacer(),
                        LogoutButton(
                          onPressed: () {
                            PopUpAcceptable(
                              color: Colors.red,
                              description: 'Are you sure?',
                              title: 'Logging out',
                              rightButtonText: 'Logout',
                              leftButtonText: 'Cancel',
                              leftButtonOnPressed: () {
                                Navigator.of(context).pop();
                              },
                              svgIcon: IconPathConstants.logoutIcon,
                              rightButtonOnPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  EventLogout(),
                                );
                              },
                            ).show(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateLoadingLogout) {
      const PopUpLoading().show(context);
    }

    if (state is StateSuccessfulLogout) {
      context.pageTransitionFade(
        page: const SignInPage(),
      );
    }

    if (state is StateFailedLogout) {
      Navigator.of(context).pop();

      UserModelException exception = state.exception;
      if (exception is UserGenericException) {
        PopUpMessage.danger(
          title: 'Bir hata olustu',
          message: 'Beklenmedik bir hata olustu',
        ).show(context);
      }
    }

    if (state is StateLoadingSendEmailVerification) {
      const PopUpLoading().show(context);
    }

    if (state is StateSuccessfulSendEmailVerification) {
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
          await OpenMailApp.openMailApp();
          Navigator.of(context).pop();
        },
      ).show(context);
      BlocProvider.of<AuthBloc>(context).add(
        EventIsUserVerified(),
      );
    }

    if (state is StateFailedSendEmailVerification) {
      UserModelException exception = state.exception;
      if (exception is UserGenericException) {
        PopUpMessage.danger(
          title: 'Beklenmedik Bir Hata',
          message: exception.toString(),
        ).show(context);
      }
    }

    if (state is StateFalseIsUserVerified) {
      await Future.delayed(
        const Duration(seconds: 1),
      );
      BlocProvider.of<AuthBloc>(context).add(
        EventIsUserVerified(),
      );
    }

    if (state is StateTrueIsUserVerified) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventIsUserProfileCreated(),
      );
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (previous is StateLoadingLogout && current is! StateLoadingLogout) {
      Navigator.of(context).pop();
    }
    if (previous is StateLoadingSendEmailVerification && current is! StateLoadingSendEmailVerification) {
      Navigator.of(context).pop();
    }
    return true;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateLoadingIsUserProfileCreated) {
      const PopUpLoading().show(context);
    }
    if (state is StateTrueUserProfileCreated) {
      context.pageTransitionFade(
        page: const HomePage(),
      );
    }
    if (state is StateTrueUserProfileCreated) {
      context.pageTransitionFade(
        page: const CreateProfilePage(),
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
