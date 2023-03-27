import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/constants/lottie_path_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/extensions/build_context_extensions.dart';
import 'package:flutter_auth/pages/email_verification_page/email_verification_page.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
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

    BlocProvider.of<AuthBloc>(context).add(
      EventCheckUserAuthentication(),
    );
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
                    Lottie.asset(
                      LottiePathConstants.introLottie,
                      repeat: true,
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

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateFalseUserLoggedIn) {
      context.pageTransitionFade(
        page: const SignInPage(),
      );
    }

    if (state is StateTrueIsUserVerified) {
      BlocProvider.of<RemoteStorageBloc>(context).add(
        EventIsUserProfileCreated(),
      );
    }

    if (state is StateFalseIsUserVerified) {
      context.pageTransitionFade(
        page: const EmailVerificationPage(),
      );
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (current is StateTrueUserLoggedIn) {
      BlocProvider.of<AuthBloc>(context).add(
        EventIsUserVerified(),
      );
      return false;
    }
    return true;
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {
    if (state is StateFalseUserProfileCreated) {
      context.pageTransitionFade(
        page: const SignInPage(),
      );
    }
    if (state is StateTrueUserProfileCreated) {
      context.pageTransitionFade(
        page: const HomePage(),
      );
    }
  }

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    return true;
  }
}
