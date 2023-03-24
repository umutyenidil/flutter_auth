import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/pages/email_verification_page/email_verification_page.dart';
import 'package:flutter_auth/pages/error_page/error_page.dart';
import 'package:flutter_auth/pages/profile_page/profile_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_auth/pages/sign_up_page/sign_up_page.dart';
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
      case RouteConstants.homePageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const SignInPage());
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
      default:
        return MaterialPageRoute(builder: (BuildContext context) => const ErrorPage());
    }
  }
}
