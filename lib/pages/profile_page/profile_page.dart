import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_auth/blocs/remote_storage_bloc/remote_storage_bloc.dart';
import 'package:flutter_auth/common_widgets/back_svg_button.dart';
import 'package:flutter_auth/common_widgets/edit_button.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_acceptable.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_loading.dart';
import 'package:flutter_auth/common_widgets/pop_ups/pop_up_message.dart';
import 'package:flutter_auth/common_widgets/vertical_space.dart';
import 'package:flutter_auth/constants/icon_path_constants.dart';
import 'package:flutter_auth/constants/route_constants.dart';
import 'package:flutter_auth/exceptions/user_model_exceptions.dart';
import 'package:flutter_auth/extensions/bool_extensions.dart';
import 'package:flutter_auth/extensions/pop_up_extensions.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/pages/profile_page/widgets/avatar_list_view.dart';
import 'package:flutter_auth/pages/profile_page/widgets/logout_button.dart';
import 'package:flutter_auth/pages/profile_page/widgets/profile_image.dart';
import 'package:flutter_auth/pages/profile_page/widgets/save_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();

    _isEditMode = false;

    BlocProvider.of<RemoteStorageBloc>(context).add(
      EventGetUserProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RemoteStorageBloc, RemoteStorageState>(
      listener: listenerRemoteStorageBloc,
      listenWhen: listenWhenRemoteStorageBloc,
      builder: (context, state) {
        if (state is StateSuccessfulGetUserProfile) {
          Map<String, dynamic> userProfileData = state.userProfileData;

          return BlocConsumer<AuthBloc, AuthState>(
            listener: listenerAuthBloc,
            listenWhen: listenWhenAuthBloc,
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            (_isEditMode).ifTrueSelectFirstWidget(
                              secondWidget: BackSvgButton(
                                size: 40,
                                padding: 4,
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    RouteConstants.homePageRoute,
                                    (route) => false,
                                  );
                                },
                              ),
                              firstWidget: Container(),
                            ),
                            const Spacer(),
                            (!_isEditMode).ifTrueSelectFirstWidget(
                              firstWidget: EditButton(
                                size: 40,
                                padding: 20,
                                onPressed: () {
                                  setState(() {
                                    _isEditMode = true;
                                  });
                                },
                              ),
                              secondWidget: BackSvgButton(
                                size: 40,
                                padding: 4,
                                onPressed: () {
                                  setState(() {
                                    _isEditMode = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox.square(
                        dimension: 120,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: MemoryImage(
                            (userProfileData[UserModelFields.avatarImage] as Blob).bytes,
                          ),
                        ),
                      ),
                      const VerticalSpace(32),
                      Text(userProfileData[UserModelFields.username]),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LogoutButton(
                          onPressed: () async {
                            await PopUpAcceptable(
                              color: Colors.red,
                              rightButtonOnPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  EventLogout(),
                                );
                                Navigator.of(context).pop();
                              },
                              svgIcon: IconPathConstants.logoutIcon,
                              description: 'Emin misiniz?',
                              title: 'Cikis yapiyorsunuz',
                              leftButtonOnPressed: () {
                                Navigator.of(context).pop();
                              },
                              leftButtonText: 'Cancel',
                              rightButtonText: 'Devam et',
                            ).show(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: PopUpLoading(),
          ),
        );
      },
    );
  }

  void listenerRemoteStorageBloc(BuildContext context, RemoteStorageState state) async {}

  bool listenWhenRemoteStorageBloc(RemoteStorageState previous, RemoteStorageState current) {
    return true;
  }

  void listenerAuthBloc(BuildContext context, AuthState state) async {
    if (state is StateLoadingLogout) {
      PopUpLoading().show(context);
    }

    if (state is StateSuccessfulLogout) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteConstants.signInPageRoute,
        (route) => false,
      );
    }

    if (state is StateFailedLogout) {
      UserModelException exception = state.exception;
      if (exception is UserGenericException) {
        PopUpMessage.danger(
          title: 'Bir hata olustu',
          message: 'Beklenmedik bir hata olustu',
        ).show(context);
      }
    }
  }

  bool listenWhenAuthBloc(AuthState previous, AuthState current) {
    if (previous is StateLoadingLogout && current is! StateLoadingLogout) {
      Navigator.of(context).pop();
    }
    return true;
  }
}
