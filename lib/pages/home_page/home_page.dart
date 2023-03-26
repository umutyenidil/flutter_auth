import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'home page',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: SizedBox.square(
          dimension: 35,
          child: SvgPicture.asset(
            IconPathConstants.userIcon,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.profilePageRoute,
            (route) => false,
          );
        },
      ),
    );
  }
}
