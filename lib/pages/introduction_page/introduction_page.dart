import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/constants/lottie_path_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/pages/email_verification_page/email_verification_page.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/profile_create_page/profile_create_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
    ).then(
      (value) {
        BlocProvider.of<AuthBloc>(context).add(
          EventIsUserSignedIn(),
        );
      },
    );

    context.dismissKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      key: UniqueKey(),
      listener: listenerAuthBloc,
      listenWhen: listenWhenAuthBloc,
      builder: (context, state) {
        return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
          listener: listenerRemoteStorageBloc,
          listenWhen: listenWhenRemoteStorageBloc,
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: context.screenWidth,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Lottie.asset(
                          LottiePathConstants.introLottie,
                          repeat: true,
                        ),
                      ),
                    ),
                    const Text(
                      'Flutter Auth',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
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

  void listenerAuthBloc(BuildContext context, AuthState state) async {}

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (previous is StateLoadingIsUserSignedIn && current is StateTrueUserSignedIn) {
      BlocProvider.of<AuthBloc>(context).add(
        EventIsUserVerified(),
      );
      return false;
    }
    if (previous is StateLoadingIsUserSignedIn && current is StateFalseUserSignedIn) {
      context.pageTransitionFade(
        page: const SignInPage(),
      );
      return false;
    }
    if (previous is StateLoadingIsUserVerified && current is StateTrueUserVerified) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventIsUserProfileCreated(),
      );
      return false;
    }
    if (previous is StateLoadingIsUserVerified && current is StateFalseUserVerified) {
      context.pageTransitionFade(
        page: const EmailVerificationPage(),
      );
      return false;
    }
    return true;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {}

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    if (previous is StateLoadingIsUserProfileCreated && current is StateTrueUserProfileCreated) {
      context.pageTransitionFade(
        page: const HomePage(),
      );
    }
    if (previous is StateLoadingIsUserProfileCreated && current is StateFalseUserProfileCreated) {
      context.pageTransitionScale(
        page: const ProfileCreatePage(),
      );
    }

    return true;
  }
}
