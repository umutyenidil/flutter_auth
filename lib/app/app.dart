import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/cubits/profile_update_page_cubit/profile_update_page_cubit.dart';
import 'package:flutter_auth/pages/email_verification_page/email_verification_page.dart';
import 'package:flutter_auth/pages/error_page/error_page.dart';
import 'package:flutter_auth/pages/home_page/home_page.dart';
import 'package:flutter_auth/pages/introduction_page/introduction_page.dart';
import 'package:flutter_auth/pages/profile_page/profile_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_auth/pages/sign_up_page/sign_up_page.dart';
import 'package:flutter_auth/pages/profile_create_page/profile_create_page.dart';
import 'package:flutter_auth/pages/test_page/test_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<RemoteStorageBloc>(
          create: (BuildContext context) => RemoteStorageBloc(),
        ),
        BlocProvider<ProfileUpdatePageCubit>(
          create: (BuildContext context) => ProfileUpdatePageCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        onGenerateRoute: onGenerateRoute,
        theme: ThemeData(
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (BuildContext context) => const TestPage());
      // case RouteConstants.introductionPageRoute:
      //   return MaterialPageRoute(builder: (BuildContext context) => const IntroductionPage());
      case RouteConstants.signUpPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const SignUpPage());
      case RouteConstants.signInPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const SignInPage());
      case RouteConstants.errorPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const ErrorPage());
      case RouteConstants.emailVerificationPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const EmailVerificationPage());
      case RouteConstants.profilePageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const ProfilePage());
      case RouteConstants.homePageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const HomePage());
      case RouteConstants.createProfilePageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const ProfileCreatePage());
      default:
        return MaterialPageRoute(builder: (BuildContext context) => const ErrorPage());
    }
  }
}
