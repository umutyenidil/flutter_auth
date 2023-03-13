import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/view/home_page/home_page.dart';
import 'package:flutter_auth/view/sign_up_page/sign_up_page.dart';

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
      default:
        return MaterialPageRoute(builder: (BuildContext context) => const HomePage());
    }
  }
}
