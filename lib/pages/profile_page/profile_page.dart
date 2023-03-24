import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/constants/border_radius_constants.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/pages/profile_page/widgets/logout_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLogoutLoading) {
          PopUpLoading().show(context);
        }

        if (state is AuthStateLogoutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.signInPageRoute,
            (route) => false,
          );
        }

        if (state is AuthStateLogoutFailed) {
          Navigator.of(context).pop();

          UserModelException exception = state.exception;
          if (exception is UserGenericException) {
            PopUpMessage.danger(
              title: 'Bir hata olustu',
              message: 'Beklenmedik bir hata olustu',
            ).show(context);
          }
        }
      },
      listenWhen: (previous, current) {
        if (previous is AuthStateLogoutLoading && current is! AuthStateLogoutLoading) {
          Navigator.of(context).pop();
        }
        return true;
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  children: [
                    const Text('profile page'),
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
                              AuthEventLogout(),
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
  }
}
