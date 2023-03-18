import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/pages/error_page/error_page.dart';
import 'package:flutter_auth/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter_auth/pages/sign_up_page/sign_up_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.homePageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const SignUpPage());
      case RouteConstants.signUpPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const SignUpPage());
      case RouteConstants.signInPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const SignInPage());
      case RouteConstants.errorPageRoute:
        return MaterialPageRoute(builder: (BuildContext context) => const ErrorPage());
      default:
        return MaterialPageRoute(builder: (BuildContext context) => const ErrorPage());
    }
  }
}
