import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/image_field.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/logout_button.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/page_container.dart';
import 'package:flutter_auth/pages/email_verification_page/widgets/send_email_verification_button.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_create_page/profile_create_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> with WidgetsBindingObserver {
  late bool _isUserVerified;
  late String _userEmailAddress;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _isUserVerified = false;
    _userEmailAddress = FirebaseAuth.instance.currentUser!.email!;

    Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        if (_isUserVerified) {
          timer.cancel();
        } else {
          BlocProvider.of<AuthBloc>(context).add(
            EventIsUserVerified(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isUserVerified) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          BlocProvider.of<RemoteStorageBloc>(context).add(
            EventIsUserProfileCreated(),
          );
        });
      }
    }
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
                    const ImageField(),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Verify your email.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
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
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
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
                            Navigator.of(context).pop();
                          },
                        ).show(context);
                      },
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

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateSuccessfulSendEmailVerification) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpAcceptable(
          color: Colors.green,
          svgIcon: IconPathConstants.checkIcon,
          title: 'We sent an email',
          description: 'We sent the verification email to $_userEmailAddress',
          leftButtonText: 'Okay',
          leftButtonOnPressed: () {
            Navigator.of(context).pop();
          },
          rightButtonText: 'Open mail app',
          rightButtonOnPressed: () async {
            await OpenMailApp.openMailApp();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ).show(context);
      }
      return;
    }
    if (state is StateFailedSendEmailVerification) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.danger(
          title: 'bir seyelr ters gtit',
          message: state.errorMessage,
        ).show(context);
      }
      return;
    }
    if (state is StateFailedLogout) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.danger(
          title: 'bir seyelr ters gtit',
          message: state.errorMessage,
        ).show(context);

        // Exception exception = state.exception;
        // await PopUpMessage.danger(
        //   title: 'Something went wrong',
        //   message: 'You didn\'t logged out. Please try again',
        // ).show(context);
      }
      return;
    }
    if (state is StateSuccessfulLogout) {
      context.delayedPop();
      if (context.mounted) {
        context.pageTransitionFade(
          page: const SignInPage(),
        );
      }
      return;
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (current is StateLoadingSendEmailVerification) {
      const PopUpLoading().show(context);
      return false;
    }
    if (previous is StateLoadingIsUserVerified && current is StateTrueUserVerified) {
      _isUserVerified = true;
      return false;
    }
    if (current is StateLoadingLogout) {
      const PopUpLoading().show(context);
      return false;
    }
    return true;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateTrueUserProfileCreated) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'You are verified now',
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
          title: 'You are verified now',
          message: 'You are being redirected to the profile creation page',
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const ProfileCreatePage(),
        );
      }
      return;
    }
    if (state is StateFailedIsUserProfileCreated) {
      await context.delayedPop();
      if (context.mounted) {
        await PopUpMessage.success(
          title: 'Something went wrong',
          message: state.errorMessage,
        ).show(context);
      }
      if (context.mounted) {
        context.pageTransitionFade(
          page: const SignInPage(),
        );
      }
      return;
    }
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (current is StateLoadingIsUserProfileCreated) {
      const PopUpLoading().show(context);
      return false;
    }
    return true;
  }
}
